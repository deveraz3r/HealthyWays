import 'package:healthyways/core/common/controllers/app_profile_controller.dart';
import 'package:healthyways/core/common/custom_types/role.dart';
import 'package:healthyways/core/theme/app_theme.dart';
import 'package:healthyways/features/auth/presentation/pages/sign_in_page.dart';
import 'package:healthyways/features/doctor/presentation/pages/doctor_home_page.dart';
import 'package:healthyways/features/measurements/presentation/controllers/measurement_controller.dart';
import 'package:healthyways/features/medication/presentation/controllers/medication_controller.dart';
import 'package:healthyways/features/patient/presentation/pages/patient_home_page.dart';
import 'package:healthyways/init_controllers.dart';
import 'package:healthyways/init_dependences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthyways/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Show loading indicator while initializing
  runApp(const SplashScreen());

  await initDependencies();

  // Initialize controllers on the main thread but lazily
  initializeControllers();

  //TODO: remove after adding a permenant fix
  await Get.find<MedicationController>().getAllMedications();
  await Get.find<MeasurementController>().getAllMeasurements();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final AppProfileController _appProfileController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blog App',
      theme: AppTheme.darkThemeMode,
      home: Obx(() {
        return _appProfileController.profile.isSuccess
            ? _getHomePageByRole(_appProfileController.profile.rxData.value!.selectedRole)
            : LoginPage();
      }),
    );
  }

  Widget _getHomePageByRole(Role selectedRole) {
    switch (selectedRole) {
      case Role.patient:
        return const PatientHomePage();
      case Role.doctor:
        return DoctorHomePage();
      // return const DoctorHomePage();
      case Role.pharmacist:
      // return const PharmacistHomePage();
      default:
        // Fallback to login if role is invalid
        return const LoginPage();
    }
  }
}
