import 'dart:io';
import 'package:get/get.dart';
import 'package:healthyways/core/common/controllers/app_profile_controller.dart';
import 'package:healthyways/features/allergies/presentation/controllers/allergie_controller.dart';
import 'package:healthyways/features/auth/presentation/controller/auth_controller.dart';
import 'package:healthyways/features/diary/presentation/controllers/diary_controller.dart';
import 'package:healthyways/features/doctor/presentation/controllers/doctor_controller.dart';
import 'package:healthyways/features/immunization/presentation/controllers/immunization_controller.dart';
import 'package:healthyways/features/measurements/presentation/controllers/measurement_controller.dart';
import 'package:healthyways/features/medication/presentation/controllers/medication_controller.dart';
import 'package:healthyways/features/patient/presentation/controllers/patient_controller.dart';
import 'package:healthyways/features/permission_requests/presentation/controllers/premission_request_controller.dart';
import 'package:healthyways/features/pharmacist/presentation/controllers/pharmacist_controller.dart';
import 'package:healthyways/features/updates/presentation/controllers/updates_controller.dart';
import 'package:healthyways/init_dependences.dart';

void initializeControllers() {
  // First initialize app-level controllers
  // Get.put(serviceLocator<AppDoctorController>());
  // Get.put(serviceLocator<AppPharmacistController>());
  Get.put(serviceLocator<AppProfileController>());

  // Then initialize feature controllers
  Get.put(serviceLocator<AuthController>());
  Get.put(serviceLocator<PatientController>());
  Get.put(serviceLocator<DoctorController>());
  Get.put(serviceLocator<PharmacistController>());
  Get.put(serviceLocator<MedicationController>());
  Get.put(serviceLocator<MeasurementController>());
  Get.put(serviceLocator<UpdatesController>());
  Get.put(serviceLocator<DiaryController>());
  Get.put(serviceLocator<ImmunizationController>());
  Get.put(serviceLocator<AllergiesController>());
  Get.put(serviceLocator<PermissionRequestController>());
}
