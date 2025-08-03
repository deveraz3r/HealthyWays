import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthyways/core/common/controllers/app_profile_controller.dart';
import 'package:healthyways/core/common/widgets/loader.dart';
import 'package:healthyways/core/theme/app_pallete.dart';
import 'package:healthyways/features/immunization/domain/entities/immunization.dart';
import 'package:healthyways/features/immunization/presentation/controllers/immunization_controller.dart';
import 'package:healthyways/features/immunization/presentation/widgets/immunization_card.dart';
import 'package:healthyways/features/immunization/presentation/widgets/immunization_entry_dialog.dart';

class ImmunizationHomePage extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (_) => const ImmunizationHomePage());
  const ImmunizationHomePage({super.key});

  @override
  State<ImmunizationHomePage> createState() => _ImmunizationHomePageState();
}

class _ImmunizationHomePageState extends State<ImmunizationHomePage> {
  final ImmunizationController _immunizationController = Get.find();

  @override
  void initState() {
    super.initState();

    final currentUser = Get.find<AppProfileController>().profile.data!;
    final isPatient = currentUser.selectedRole.name == 'patient';

    if (isPatient) {
      _immunizationController.patientId.value = currentUser.uid;
      _immunizationController.getAllImmunizationEntries();
    }
    // For providers, access check must be performed from parent via checkImmunizationAccess()
  }

  void _showAddImmunizationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => ImmunizationEntryDialog(
            onSubmit: (title, body) async {
              await _immunizationController.createImmunizationEntry(
                title: title,
                body: body,
              );
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = Get.find<AppProfileController>().profile.data!;
    final isPatient = currentUser.selectedRole.name == 'patient';

    return Scaffold(
      appBar: AppBar(
        title: const Text("Immunizations"),
        backgroundColor: AppPallete.backgroundColor2,
        actions: [
          Obx(() {
            final access = _immunizationController.immunizationAccess.value;

            if (isPatient || (access != null && access.isAllowed)) {
              return IconButton(
                icon: const Icon(CupertinoIcons.add_circled_solid),
                onPressed: () => _showAddImmunizationDialog(context),
              );
            }

            return const SizedBox.shrink();
          }),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Obx(() {
          final access = _immunizationController.immunizationAccess.value;

          if (!isPatient && access == null) {
            return const Center(child: Text("Access verification pending..."));
          }

          if (!isPatient && access != null && !access.isAllowed) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.lock_outline, size: 48, color: Colors.grey),
                  const SizedBox(height: 12),
                  Text(
                    access.message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Trigger access request logic here if needed
                      Get.snackbar(
                        "Access Request",
                        "Your request has been sent to the patient.",
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                    child: const Text("Request Access"),
                  ),
                ],
              ),
            );
          }

          if (_immunizationController.immunizationEntries.isLoading) {
            return const Loader();
          }

          if (_immunizationController.immunizationEntries.hasError) {
            return Center(
              child: Text(
                _immunizationController.immunizationEntries.error!.message,
              ),
            );
          }

          if (_immunizationController.immunizationEntries.hasData &&
              _immunizationController.immunizationEntries.data!.isEmpty) {
            return Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "No Immunization Entries yet, ",
                    style: TextStyle(fontSize: 18),
                  ),
                  InkWell(
                    onTap:
                        () async =>
                            await _immunizationController
                                .getAllImmunizationEntries(),
                    child: Text(
                      "retry",
                      style: TextStyle(
                        fontSize: 18,
                        color: AppPallete.gradient1,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            itemCount:
                _immunizationController
                    .immunizationEntries
                    .rxData
                    .value!
                    .length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final immunization =
                  _immunizationController
                      .immunizationEntries
                      .rxData
                      .value![index];
              return ImmunizationCard(immunization: immunization);
            },
          );
        }),
      ),
    );
  }
}
