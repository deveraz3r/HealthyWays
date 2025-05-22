import 'package:healthyways/core/common/controllers/app_doctor_controller.dart';
import 'package:healthyways/core/common/controllers/app_patient_controller.dart';
import 'package:healthyways/core/common/controllers/app_pharmacist_controller.dart';
import 'package:healthyways/core/common/controllers/app_profile_controller.dart';
import 'package:healthyways/core/common/custom_types/role.dart';
import 'package:healthyways/core/theme/app_theme.dart';
import 'package:healthyways/features/auth/presentation/controller/auth_controller.dart';
import 'package:healthyways/features/auth/presentation/pages/sign_in_page.dart';
import 'package:healthyways/features/doctor/presentation/controllers/doctor_controller.dart';
import 'package:healthyways/features/patient/presentation/controllers/patient_controller.dart';
import 'package:healthyways/features/patient/presentation/pages/patient_home_page.dart';
import 'package:healthyways/features/pharmacist/presentation/controllers/pharmacist_controller.dart';
import 'package:healthyways/init_dependences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initDependencies();

  // Inject the GetX controller from GetIt
  Get.put(serviceLocator<AuthController>());
  Get.put(serviceLocator<PatientController>());
  // Get.put(serviceLocator<DoctorController>());
  // Get.put(serviceLocator<PharmacistController>());

  Get.put(serviceLocator<AppProfileController>());
  Get.put(serviceLocator<AppPatientController>());
  // Get.put(serviceLocator<AppDoctorController>());
  // Get.put(serviceLocator<AppPharmacistController>());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final AppProfileController _appProfileController = Get.find();

  @override
  Widget build(BuildContext context) {
    final profile = _appProfileController.profile;
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blog App',
      theme: AppTheme.darkThemeMode,
      home: Obx(
        () =>
            profile.isSuccess
                ? _getHomePageByRole(profile.data!.selectedRole)
                : LoginPage(),
      ),
    );
  }

  Widget _getHomePageByRole(Role selectedRole) {
    switch (selectedRole) {
      case Role.patient:
        return const PatientHomePage();
      case Role.doctor:
      // return const DoctorHomePage();
      case Role.pharmacist:
      // return const PharmacistHomePage();
      default:
        // Fallback to login if role is invalid
        return const LoginPage();
    }
  }
}
