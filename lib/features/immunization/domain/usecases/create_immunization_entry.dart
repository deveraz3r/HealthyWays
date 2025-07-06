import 'package:fpdart/fpdart.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/core/usecase/usecase.dart';
import 'package:healthyways/features/immunization/domain/repositories/immunization_repository.dart';
import 'package:healthyways/features/immunization/domain/entities/immunization.dart';

class CreateImmunizationEntry implements UseCase<void, CreateImmunizationEntryParams> {
  final ImmunizationRepository repository;
  CreateImmunizationEntry(this.repository);

  @override
  Future<Either<Failure, void>> call(params) async {
    return await repository.createImmunizationEntry(params.immunization);
  }
}

class CreateImmunizationEntryParams {
  Immunization immunization;

  CreateImmunizationEntryParams({required this.immunization});
}
