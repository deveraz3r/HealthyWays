import 'package:fpdart/fpdart.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/core/usecase/usecase.dart';
import 'package:healthyways/features/allergies/domain/entities/allergy.dart';
import 'package:healthyways/features/allergies/domain/repositories/allergie_repository.dart';

class CreateAllergyEntry implements UseCase<void, CreateAllergieEntryParams> {
  final AllergiesRepository repository;
  CreateAllergyEntry(this.repository);

  @override
  Future<Either<Failure, void>> call(params) async {
    return await repository.createAllergieEntry(params.allergie);
  }
}

class CreateAllergieEntryParams {
  Allergy allergie;

  CreateAllergieEntryParams({required this.allergie});
}
