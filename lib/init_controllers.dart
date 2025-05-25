import 'package:get/get.dart';
import 'package:healthyways/core/common/controllers/app_medications_controller.dart';
import 'package:healthyways/core/common/controllers/app_patient_controller.dart';
import 'package:healthyways/core/common/controllers/app_profile_controller.dart';
import 'package:healthyways/features/auth/presentation/controller/auth_controller.dart';
import 'package:healthyways/features/medication/presentation/controllers/medication_controller.dart';
import 'package:healthyways/features/patient/presentation/controllers/patient_controller.dart';
import 'package:healthyways/init_dependences.dart';

void initializeControllers() {
  // First initialize app-level controllers
  Get.put(serviceLocator<AppProfileController>());
  Get.put(serviceLocator<AppPatientController>());
  // Get.put(serviceLocator<AppDoctorController>());
  // Get.put(serviceLocator<AppPharmacistController>());

  // Then initialize feature controllers
  Get.put(serviceLocator<AuthController>());
  Get.put(serviceLocator<PatientController>());
  // Get.put(serviceLocator<DoctorController>());
  // Get.put(serviceLocator<PharmacistController>());
  Get.put(serviceLocator<MedicationController>());
}
