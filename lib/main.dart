import 'package:healthyways/app.dart';
import 'package:healthyways/features/measurements/presentation/controllers/measurement_controller.dart';
import 'package:healthyways/features/medication/presentation/controllers/medication_controller.dart';
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
  initializeControllers();

  //TODO: remove after adding a permenant fix
  await Get.find<MedicationController>().getAllMedications();
  await Get.find<MeasurementController>().getAllMeasurements();

  runApp(MyApp());
}
