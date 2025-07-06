import 'package:fpdart/fpdart.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/core/usecase/usecase.dart';
import 'package:healthyways/features/immunization/domain/repositories/immunization_repository.dart';
import 'package:healthyways/features/immunization/domain/entities/immunization.dart';

class GetAllImmunizationEntries implements UseCase<List<Immunization>, NoParams> {
  final ImmunizationRepository repository;
  GetAllImmunizationEntries(this.repository);

  @override
  Future<Either<Failure, List<Immunization>>> call(params) async {
    return await repository.getAllImmunizationEntries();
  }
}
