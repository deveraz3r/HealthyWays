import 'package:healthyways/core/controller/controller_state_manager.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/core/common/entites/pharmacist_profile.dart';
import 'package:healthyways/core/usecase/usecase.dart';
import 'package:healthyways/features/pharmacist/domain/usecases/get_all_pharmacists.dart';
import 'package:healthyways/features/pharmacist/domain/usecases/get_pharmacist_by_id.dart';
import 'package:healthyways/features/pharmacist/domain/usecases/update_pharmacist_profile.dart';
import 'package:get/get.dart';

class PharmacistController extends GetxController {
  final GetAllPharmacists _getAllPharmacists;
  final GetPharmacistById _getPharmacistById;
  final UpdatePharmacistProfile _updatePharmacistProfile;

  PharmacistController({
    required GetAllPharmacists getAllPharmacists,
    required GetPharmacistById getPharmacistById,
    required UpdatePharmacistProfile updatePharmacistProfile,
  }) : _getAllPharmacists = getAllPharmacists,
       _getPharmacistById = getPharmacistById,
       _updatePharmacistProfile = updatePharmacistProfile;

  final pharmacists = StateController<Failure, List<PharmacistProfile>>();
  final selectedPharmacist = StateController<Failure, PharmacistProfile>();

  Future<void> fetchAllPharmacists() async {
    pharmacists.setLoading();

    final result = await _getAllPharmacists(NoParams());

    result.fold(
      (failure) {
        pharmacists.setError(failure);
      },
      (pharmacistList) {
        pharmacists.setData(pharmacistList);
      },
    );
  }

  Future<void> fetchPharmacistById(String uid) async {
    selectedPharmacist.setLoading();

    final result = await _getPharmacistById(GetPharmacistByIdParams(uid));

    result.fold(
      (failure) {
        selectedPharmacist.setError(failure);
      },
      (pharmacist) {
        selectedPharmacist.setData(pharmacist);
      },
    );
  }

  Future<void> updatePharmacistProfile(PharmacistProfile pharmacist) async {
    selectedPharmacist.setLoading();

    final result = await _updatePharmacistProfile(
      UpdatePharmacistProfileParams(pharmacist: pharmacist),
    );

    result.fold(
      (failure) {
        selectedPharmacist.setError(failure);
      },
      (_) {
        // Refresh the list after update
        fetchAllPharmacists();
      },
    );
  }
}
