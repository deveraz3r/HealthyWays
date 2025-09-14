import 'package:flutter/material.dart';
import 'package:healthyways/core/common/custom_types/role.dart';
import 'package:healthyways/features/auth/presentation/pages/sign_in_page.dart';
import 'package:healthyways/features/doctor/presentation/pages/doctor_home_page.dart';
import 'package:healthyways/features/patient/presentation/pages/patient_home_page.dart';
import 'package:healthyways/features/pharmacist/presentation/pages/pharmacist_home_page.dart';

Widget getHomePageByRole(Role selectedRole) {
  switch (selectedRole) {
    case Role.patient:
      return const PatientHomePage();
    case Role.doctor:
      return DoctorHomePage();
    // return const DoctorHomePage();
    case Role.pharmacist:
      return const PharmacistHomePage();
    // return const PharmacistHomePage();
    default:
      // Fallback to login if role is invalid
      return const LoginPage();
  }
}
