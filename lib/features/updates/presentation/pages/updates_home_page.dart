import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthyways/features/updates/presentation/controllers/updates_controller.dart';
import 'package:healthyways/features/updates/presentation/widgets/medication_schedule_report_widget.dart';
import 'package:healthyways/init_dependences.dart';

class UpdatesHomePage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const UpdatesHomePage());
  const UpdatesHomePage({super.key});

  @override
  State<UpdatesHomePage> createState() => _UpdatesHomePageState();
}

class _UpdatesHomePageState extends State<UpdatesHomePage> {
  final UpdatesController updatesController = Get.put(serviceLocator<UpdatesController>());

  @override
  void initState() {
    super.initState();
    updatesController.getAllMedicationScheduleReports();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (updatesController.allMedicationScheduleReport.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (updatesController.allMedicationScheduleReport.hasError) {
          return Center(
            child: Text(
              'Error: ${updatesController.allMedicationScheduleReport.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        final schedules = updatesController.allMedicationScheduleReport.data ?? [];

        if (schedules.isEmpty) {
          return const Center(child: Text('No updates available'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: schedules.length,
          itemBuilder: (context, index) {
            return MedicationScheduleCard(schedule: schedules[index]);
          },
        );
      }),
    );
  }
}
