import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthyways/core/common/custom_types/role.dart';
import 'package:healthyways/features/updates/presentation/controllers/updates_controller.dart';
import 'package:healthyways/features/updates/presentation/widgets/medication_schedule_report_widget.dart';
import 'package:healthyways/features/updates/presentation/widgets/schedule_shimmer_card.dart';
import 'package:healthyways/init_dependences.dart';

class UpdatesHomePage extends StatefulWidget {
  static route({required String uid, required Role role}) =>
      MaterialPageRoute(builder: (_) => UpdatesHomePage(uid: uid, role: role));

  final String uid;
  final Role role;
  const UpdatesHomePage({super.key, required this.uid, required this.role});

  @override
  State<UpdatesHomePage> createState() => _UpdatesHomePageState();
}

class _UpdatesHomePageState extends State<UpdatesHomePage> {
  final UpdatesController updatesController = Get.put(
    serviceLocator<UpdatesController>(),
  );

  @override
  void initState() {
    super.initState();
    updatesController.getAllMedicationScheduleReports(
      uid: widget.uid,
      role: widget.role,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (updatesController.allMedicationScheduleReport.isLoading) {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: 3, // Show 3 shimmer cards
            itemBuilder:
                (_, __) => const Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: ScheduleShimmerCard(),
                ),
          );
        }

        if (updatesController.allMedicationScheduleReport.hasError) {
          return Center(
            child: Text(
              'Error: ${updatesController.allMedicationScheduleReport.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        final schedules =
            updatesController.allMedicationScheduleReport.data ?? [];

        if (schedules.isEmpty) {
          return const Center(child: Text('No updates available'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: schedules.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: MedicationScheduleCard(schedule: schedules[index]),
            );
          },
        );
      }),
    );
  }
}
