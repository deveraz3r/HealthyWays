import 'package:get/get.dart';
import 'package:healthyways/core/common/entites/pharmacist_profile.dart';
import 'package:healthyways/core/controller/controller_state_manager.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/core/usecase/usecase.dart';
import 'package:healthyways/features/pharmacist/domain/usecases/get_all_pharmacists.dart';
import 'package:healthyways/features/pharmacist/domain/usecases/get_pharmacist_by_id.dart';
import 'package:healthyways/features/pharmacist/domain/usecases/update_pharmacist_profile.dart';

class PharmacistController extends GetxController {
  final GetPharmacistById _getPharmacistById;
  final GetAllPharmacists _getAllPharmacists;
  final UpdatePharmacistProfile _updatePharmacistProfile;

  PharmacistController({
    required GetPharmacistById getPharmacistById,
    required GetAllPharmacists getAllPharmacists,
    required UpdatePharmacistProfile updatePharmacistProfile,
  }) : _getPharmacistById = getPharmacistById,
       _getAllPharmacists = getAllPharmacists,
       _updatePharmacistProfile = updatePharmacistProfile;

  final pharmacist = StateController<Failure, PharmacistProfile>();
  final allPharmacists = StateController<Failure, List<PharmacistProfile>>();

  // ========================== Public Methods ===============================

  Future<void> getPharmacistById(String uid) async {
    pharmacist.setLoading();

    final result = await _getPharmacistById(GetPharmacistByIdParams(uid: uid));

    result.fold(
      (failure) => pharmacist.setError(failure),
      (data) => pharmacist.setData(data),
    );
  }

  Future<void> getAllPharmacists() async {
    allPharmacists.setLoading();

    final result = await _getAllPharmacists(NoParams());

    result.fold(
      (failure) => allPharmacists.setError(failure),
      (data) => allPharmacists.setData(data),
    );
  }

  Future<void> updatePharmacist(PharmacistProfile updatedProfile) async {
    pharmacist.setLoading();

    final result = await _updatePharmacistProfile(
      UpdatePharmacistProfileParams(pharmacist: updatedProfile),
    );

    result.fold(
      (failure) => pharmacist.setError(failure),
      (_) => pharmacist.setData(updatedProfile),
    );
  }
}
