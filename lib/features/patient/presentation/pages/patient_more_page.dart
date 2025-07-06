import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:healthyways/core/common/controllers/app_profile_controller.dart';
import 'package:healthyways/core/theme/app_pallete.dart';
import 'package:healthyways/features/diary/presentation/pages/diary_home_page.dart';
import 'package:healthyways/features/doctor/presentation/pages/all_doctors_page.dart';
import 'package:healthyways/features/immunization/presentation/pages/immunization_home_page.dart';
// import 'package:healthyways/features/immunization/presentation/pages/immunization_home_page.dart';
import 'package:healthyways/features/measurements/presentation/pages/my_measurements_page.dart';
import 'package:healthyways/features/medication/presentation/pages/add_new_medication_page.dart';
import 'package:healthyways/features/pharmacist/presentation/pages/all_pharmacists_page.dart';

class PatientMorePage extends StatelessWidget {
  static route() => MaterialPageRoute(builder: (context) => PatientMorePage());
  PatientMorePage({super.key});

  final AppProfileController _appProfileController = Get.find<AppProfileController>();

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> items = [
      {
        'title': 'Doctors',
        'icon': Icons.medical_services,
        'onTap': () {
          Navigator.push(context, AllDoctorsPage.route());
          print("Doctors tapped");
        },
      },
      {
        'title': 'Pharmacists',
        'icon': Icons.local_pharmacy,
        'onTap': () {
          Navigator.push(context, AllPharmacistsPage.route());
          print("Pharmacists tapped");
        },
      },
      {
        'title': 'Trackers',
        'icon': Icons.monitor_heart,
        'onTap': () {
          print("Measurements tapped");
          Navigator.push(context, MyMeasurementsPage.route());
        },
      },
      // {
      //   'title': 'Medical Records',
      //   'icon': Icons.folder_shared,
      //   'onTap': () {
      //     print("Medical Records tapped");
      //   },
      // },
      {
        'title': 'Allergies',
        'icon': Icons.warning_amber,
        'onTap': () {
          print("Allergies tapped");
        },
      },
      {
        'title': 'Immunizations',
        'icon': Icons.vaccines,
        'onTap': () {
          Navigator.push(context, ImmunizationHomePage.route());
          print("Immunizations tapped");
        },
      },
      {
        'title': 'Diary',
        'icon': Icons.note,
        'onTap': () {
          Navigator.push(context, DiaryHomePage.route());
          print("Diary tapped");
        },
      },
      {
        'title': 'Add Medication',
        'icon': Icons.add,
        'onTap': () {
          Navigator.push(context, AddNewMedicationPage.route(assignedTo: _appProfileController.profile.data!.uid));
          print("Add Medication tapped");
        },
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Healthy Ways"),
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.home)),
        backgroundColor: AppPallete.backgroundColor2,
      ),
      body: ListView.separated(
        itemCount: items.length,
        separatorBuilder:
            (context, index) => Divider(color: AppPallete.greyColor.withOpacity(0.3), thickness: 0.5, height: 1),
        itemBuilder: (context, index) {
          final item = items[index];
          return ListTile(
            leading: Icon(item['icon'], color: AppPallete.gradient1),
            title: Text(item['title'], style: const TextStyle(fontSize: 16)),
            onTap: item['onTap'],
          );
        },
      ),
    );
  }
}
