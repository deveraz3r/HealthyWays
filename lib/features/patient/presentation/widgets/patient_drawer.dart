import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthyways/core/common/controllers/app_patient_controller.dart';

class PatientDrawer extends StatelessWidget {
  const PatientDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final appPatientController = Get.find<AppPatientController>();

    return Drawer(
      child: Obx(() {
        if (appPatientController.patient.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (appPatientController.patient.hasError) {
          return Center(
            child: Text(
              'Error: ${appPatientController.patient.errorMessage?.message}',
            ),
          );
        } else if (appPatientController.patient.hasData) {
          final patient = appPatientController.patient.data!;
          return ListView(
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(color: Colors.blue),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // CircleAvatar(
                    //   radius: 40,
                    //   backgroundImage: AssetImage(
                    //     'assets/images/profile_placeholder.png',
                    //   ),
                    // ),
                    // const SizedBox(height: 10),
                    Text(
                      '${patient.fName ?? "Unknown"} ${patient.lName ?? "User"}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      patient.email ?? "No email available",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: Text(
                  '${patient.fName ?? "Unknown"} ${patient.lName ?? "User"}',
                ),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: Text(patient.email ?? "No email available"),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Profile'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.help),
                title: const Text('Help & Support'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () {},
              ),
            ],
          );
        } else {
          return const Center(child: Text('No patient data available.'));
        }
      }),
    );
  }
}
