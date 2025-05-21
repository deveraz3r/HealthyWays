import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthyways/core/common/controllers/app_profile_controller.dart';
import 'package:healthyways/core/theme/app_pallete.dart';
import 'package:healthyways/features/auth/presentation/controller/auth_controller.dart';
import 'package:healthyways/features/patient/presentation/controllers/patient_controller.dart';

class PatientDrawer extends StatelessWidget {
  PatientDrawer({super.key});
  final PatientController _patientController = Get.find();
  final AppProfileController _appProfileController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: AppPallete.blueColor),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CircleAvatar(
                  radius: 40,
                  // backgroundImage: AssetImage(
                  //   // _patientController.patient.data.imageUrl
                  //   //TODO: Replace with image
                  //   'assets/images/profile_placeholder.png',
                  // ),
                ),
                SizedBox(height: 10),
                Center(
                  child: Text(
                    _appProfileController.profile.data?.email ??
                        'guest@example.com',
                    style: TextStyle(
                      color: Colors.white,
                      // fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(_appProfileController.profile.data?.fName ?? "Guest"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(
              _appProfileController.profile.data?.selectedRole.name ?? 'Null',
            ),
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
            onTap: () {
              Get.find<AuthController>().signOut();
            },
          ),
        ],
      ),
    );
  }
}
