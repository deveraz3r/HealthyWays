import 'package:healthyways/core/common/controllers/app_patient_controller.dart';
import 'package:healthyways/core/common/controllers/app_doctor_controller.dart';
import 'package:healthyways/core/common/controllers/app_pharmacist_controller.dart';
import 'package:healthyways/core/common/custom_types/role.dart';
import 'package:healthyways/core/common/entites/profile.dart';
import 'package:healthyways/core/controller/controller_state_manager.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:get/get.dart';

class AppProfileController extends GetxController {
  final profile = StateController<Failure, Profile?>();

  void updateProfile(Profile? newProfile) {
    if (newProfile == null) {
      profile.reset();
    } else {
      profile.setData(newProfile);
      updateRoleBasedProfile(newProfile);
    }
  }

  //update role model
  Future<void> updateRoleBasedProfile(Profile newProfile) async {
    switch (newProfile.selectedRole) {
      case Role.patient:
        Get.find<AppPatientController>().getPatientById(newProfile.uid);
        break;
      case Role.doctor:
        Get.find<AppDoctorController>().getDoctorById(newProfile.uid);
        break;
      case Role.pharmacist:
        Get.find<AppPharmacistController>().getPharmacistById(newProfile.uid);
        break;
    }
  }
}
