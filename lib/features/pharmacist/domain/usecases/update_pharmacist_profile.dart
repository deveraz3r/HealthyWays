import 'package:fpdart/fpdart.dart';
import 'package:healthyways/core/common/entites/pharmacist_profile.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/core/usecase/usecase.dart';
import 'package:healthyways/features/pharmacist/domain/repositories/pharmacist_repository.dart';

class UpdatePharmacistProfile
    implements UseCase<void, UpdatePharmacistProfileParams> {
  final PharmacistRepository repo;

  UpdatePharmacistProfile(this.repo);

  @override
  Future<Either<Failure, void>> call(params) async {
    return await repo.updatePharmacist(params.pharmacist);
  }
}

class UpdatePharmacistProfileParams {
  PharmacistProfile pharmacist;
  UpdatePharmacistProfileParams({required this.pharmacist});
}
