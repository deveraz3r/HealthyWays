import 'package:fpdart/fpdart.dart';
import 'package:healthyways/core/common/entites/pharmacist_profile.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/core/usecase/usecase.dart';
import 'package:healthyways/features/pharmacist/domain/repositories/pharmacist_repository.dart';

class GetPharmacistById
    implements UseCase<PharmacistProfile, GetPharmacistByIdParams> {
  final PharmacistRepository repo;
  GetPharmacistById(this.repo);

  @override
  Future<Either<Failure, PharmacistProfile>> call(
    GetPharmacistByIdParams params,
  ) async {
    return await repo.getPharmacistById(params.uid);
  }
}

class GetPharmacistByIdParams {
  String uid;
  GetPharmacistByIdParams({required this.uid});
}
