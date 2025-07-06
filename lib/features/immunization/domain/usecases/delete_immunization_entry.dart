import 'package:fpdart/fpdart.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/core/usecase/usecase.dart';
import 'package:healthyways/features/immunization/domain/repositories/immunization_repository.dart';

class DeleteImmunizationEntry implements UseCase<void, DeleteImmunizationEntryParams> {
  final ImmunizationRepository repository;
  DeleteImmunizationEntry(this.repository);

  @override
  Future<Either<Failure, void>> call(params) async {
    return await repository.deleteImmunizationEntry(params.id);
  }
}

class DeleteImmunizationEntryParams {
  String id;

  DeleteImmunizationEntryParams({required this.id});
}
