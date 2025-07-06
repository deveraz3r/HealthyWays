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
    }
  }
}
