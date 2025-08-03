import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/instance_manager.dart';
import 'package:healthyways/core/theme/app_pallete.dart';
import 'package:healthyways/features/doctor/presentation/controllers/doctor_home_page_controller.dart';
import 'package:healthyways/features/doctor/presentation/pages/add_patient_page.dart';
import 'package:healthyways/features/patient/presentation/pages/all_patients_page.dart';

class DoctorMainScreen extends StatefulWidget {
  const DoctorMainScreen({super.key});

  @override
  State<DoctorMainScreen> createState() => _DoctorMainScreenState();
}

class _DoctorMainScreenState extends State<DoctorMainScreen> {
  @override
  Widget build(BuildContext context) {
    final List<Map> homeTiles = [
      {
        "onTap": () {
          Navigator.push(context, AllPatientsPage.route());
        },
        "title": "All Patients",
      },
      {
        "onTap": () {
          Get.find<DoctorHomePageController>().setCurrentIndex(3);
        },
        "title": "My Patients",
      },
      {
        "onTap": () {
          Navigator.push(context, AddPatientPage.route());
        },
        "title": "Add Patients",
      },
    ];

    return Padding(
      padding: EdgeInsets.all(15),
      child: ListView.separated(
        itemCount: homeTiles.length,
        separatorBuilder: (context, index) => SizedBox(height: 10),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: homeTiles[index]["onTap"],
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppPallete.gradient1.withAlpha((0.2 * 255).round()),
                    AppPallete.backgroundColor2,
                  ],
                ),
              ),
              child: Center(
                child: Text(
                  homeTiles[index]["title"],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
