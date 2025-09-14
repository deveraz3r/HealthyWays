import 'package:fpdart/fpdart.dart';
import 'package:healthyways/core/common/entites/pharmacist_profile.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/core/usecase/usecase.dart';
import 'package:healthyways/features/pharmacist/domain/repositories/pharmacist_repository.dart';

class GetAllPharmacists implements UseCase<List<PharmacistProfile>, NoParams> {
  final PharmacistRepository repo;
  GetAllPharmacists(this.repo);

  @override
  Future<Either<Failure, List<PharmacistProfile>>> call(NoParams params) async {
    return await repo.getAllPharmacists();
  }
}
