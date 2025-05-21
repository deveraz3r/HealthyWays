import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:healthyways/core/common/entites/patient_profile.dart';
import 'package:healthyways/core/controller/controller_state_manager.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/features/patient/presentation/controllers/patient_controller.dart';

class AppPatientController extends GetxController {
  final PatientController _patientController;

  AppPatientController({required PatientController patientController})
    : _patientController = patientController;

  // Getter to expose patient and allPatients directly
  StateController<Failure, PatientProfile> get patient =>
      _patientController.patient;
  StateController<Failure, List<PatientProfile>> get allPatients =>
      _patientController.allPatients;

  Future<void> getPatientById(String uid) async {
    await _patientController.getPatientById(uid);
  }

  Future<void> getAllPatients() async {
    await _patientController.getAllPatients();
  }

  Future<void> updatePatient(PatientProfile updatedProfile) async {
    await _patientController.updatePatient(updatedProfile);
  }
}
