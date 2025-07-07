import 'package:fpdart/fpdart.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/core/usecase/usecase.dart';
import 'package:healthyways/features/allergies/domain/repositories/allergie_repository.dart';

class DeleteAllergyEntry implements UseCase<void, DeleteAllergieEntryParams> {
  final AllergiesRepository repository;
  DeleteAllergyEntry(this.repository);

  @override
  Future<Either<Failure, void>> call(params) async {
    return await repository.deleteAllergieEntry(params.id);
  }
}

class DeleteAllergieEntryParams {
  String id;

  DeleteAllergieEntryParams({required this.id});
}
