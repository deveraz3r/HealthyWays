import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthyways/core/common/controllers/app_profile_controller.dart';
import 'package:healthyways/core/theme/app_pallete.dart';
import 'package:healthyways/features/patient/presentation/pages/patient_demographics_page.dart';
import 'package:healthyways/features/patient/presentation/pages/patient_settings_page.dart';
import 'package:healthyways/features/patient/presentation/pages/patient_visiblity_settings_page.dart';

class PatientDrawer extends StatelessWidget {
  const PatientDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final appPatientController = Get.find<AppProfileController>();

    return Drawer(
      child: Obx(() {
        if (appPatientController.profile.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (appPatientController.profile.hasError) {
          return Center(child: Text('Error: ${appPatientController.profile.error?.message}'));
        } else if (appPatientController.profile.hasData) {
          final patient = appPatientController.profile.data!;
          return ListView(
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(color: AppPallete.gradient1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(radius: 40, backgroundImage: AssetImage('assets/images/profile_placeholder.png')),
                    const SizedBox(width: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${patient.fName ?? "Unknown"} ${patient.lName ?? "User"}',
                          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          patient.email ?? "No email available",
                          style: const TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Demographics'),
                onTap: () {
                  Navigator.push(context, PatientDemographicsPage.route());
                },
              ),
              ListTile(
                leading: const Icon(Icons.remove_red_eye),
                title: const Text('Visiblity'),
                onTap: () {
                  Navigator.push(context, PatientVisibilitySettingsPage.route());
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {
                  Navigator.push(context, PatientSettingsPage.route());
                },
              ),
              ListTile(leading: const Icon(Icons.help), title: const Text('Help & Support'), onTap: () {}),
            ],
          );
        } else {
          return const Center(child: Text('No patient data available.'));
        }
      }),
    );
  }
}
