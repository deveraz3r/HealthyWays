import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthyways/core/common/controllers/app_profile_controller.dart';
import 'package:healthyways/core/common/widgets/loader.dart';
import 'package:healthyways/core/theme/app_pallete.dart';
import 'package:healthyways/features/allergies/domain/entities/allergy.dart';
import 'package:healthyways/features/allergies/presentation/controllers/allergie_controller.dart';
import 'package:healthyways/features/allergies/presentation/widgets/allergy_card.dart';
import 'package:healthyways/features/allergies/presentation/widgets/allergy_entry_dialog.dart';

class AllergyHomePage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (_) => const AllergyHomePage());
  const AllergyHomePage({super.key});

  @override
  State<AllergyHomePage> createState() => _AllergyHomePageState();
}

class _AllergyHomePageState extends State<AllergyHomePage> {
  final AllergiesController _allergyController = Get.find();

  @override
  void initState() {
    super.initState();

    final currentUser = Get.find<AppProfileController>().profile.data!;
    final isPatient = currentUser.selectedRole.name == 'patient';

    if (isPatient) {
      _allergyController.patientId.value = currentUser.uid;
      _allergyController.getAllAllergieEntries();
    }
    // If provider, `checkAllergyAccess()` should be called from the parent
  }

  void _showAddAllergyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => AllergyEntryDialog(
            onSubmit: (title, body) async {
              await _allergyController.createAllergieEntry(
                title: title,
                body: body,
              );
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Allergies"),
        backgroundColor: AppPallete.backgroundColor2,
        actions: [
          Obx(() {
            final access = _allergyController.allergieAccess.value;
            final currentUser = Get.find<AppProfileController>().profile.data!;
            final isPatient = currentUser.selectedRole.name == 'patient';

            if (isPatient || (access != null && access.isAllowed)) {
              return IconButton(
                icon: const Icon(CupertinoIcons.add_circled_solid),
                onPressed: () => _showAddAllergyDialog(context),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Obx(() {
          final access = _allergyController.allergieAccess.value;
          final currentUser = Get.find<AppProfileController>().profile.data!;
          final isPatient = currentUser.selectedRole.name == 'patient';

          // Access not yet verified
          if (!isPatient && access == null) {
            return const Center(child: Text("Access verification pending..."));
          }

          // Access denied
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

          // Loading state
          if (_allergyController.allergieEntries.isLoading) {
            return const Loader();
          }

          // Error state
          if (_allergyController.allergieEntries.hasError) {
            return Center(
              child: Text(_allergyController.allergieEntries.error!.message),
            );
          }

          // No data
          if (_allergyController.allergieEntries.hasData &&
              _allergyController.allergieEntries.data!.isEmpty) {
            return Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "No Allergy Entries yet, ",
                    style: TextStyle(fontSize: 18),
                  ),
                  InkWell(
                    onTap:
                        () async =>
                            await _allergyController.getAllAllergieEntries(),
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

          // Render data
          return ListView.separated(
            itemCount: _allergyController.allergieEntries.rxData.value!.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final allergy =
                  _allergyController.allergieEntries.rxData.value![index];
              return AllergyCard(allergy: allergy);
            },
          );
        }),
      ),
    );
  }
}
