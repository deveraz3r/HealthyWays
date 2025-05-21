import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:healthyways/core/common/entites/pharmacist_profile.dart';
import 'package:healthyways/core/controller/controller_state_manager.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/features/pharmacist/presentation/controllers/pharmacist_controller.dart';

class AppPharmacistController extends GetxController {
  final PharmacistController _pharmacistController;

  AppPharmacistController({required PharmacistController pharmacistController})
    : _pharmacistController = pharmacistController;

  // Getter to expose pharmacist and allPharmacists directly
  StateController<Failure, PharmacistProfile> get pharmacist =>
      _pharmacistController.selectedPharmacist;
  StateController<Failure, List<PharmacistProfile>> get allPharmacists =>
      _pharmacistController.pharmacists;

  Future<void> getPharmacistById(String uid) async {
    await _pharmacistController.fetchPharmacistById(uid);
  }

  Future<void> getAllPharmacists() async {
    await _pharmacistController.fetchAllPharmacists();
  }

  Future<void> updatePharmacist(PharmacistProfile updatedProfile) async {
    await _pharmacistController.updatePharmacistProfile(updatedProfile);
  }
}
