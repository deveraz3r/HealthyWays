import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:healthyways/core/common/entites/doctor_profile.dart';
import 'package:healthyways/core/controller/controller_state_manager.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/features/doctor/presentation/controllers/doctor_controller.dart';

class AppDoctorController extends GetxController {
  final DoctorController _doctorController;

  AppDoctorController({required DoctorController doctorController})
    : _doctorController = doctorController;

  // Getter to expose doctor and alldoctors directly
  StateController<Failure, DoctorProfile> get doctor =>
      _doctorController.doctor;
  StateController<Failure, List<DoctorProfile>> get alldoctors =>
      _doctorController.allDoctors;

  Future<void> getDoctorById(String uid) async {
    await _doctorController.getDoctorById(uid);
  }

  Future<void> getAlldoctors() async {
    await _doctorController.getAllDoctors();
  }

  Future<void> updatedoctor(DoctorProfile updatedProfile) async {
    await _doctorController.updateDoctor(updatedProfile);
  }
}
