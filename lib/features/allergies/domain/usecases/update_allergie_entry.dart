import 'package:fpdart/fpdart.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/core/usecase/usecase.dart';
import 'package:healthyways/features/allergies/domain/entities/allergy.dart';
import 'package:healthyways/features/allergies/domain/repositories/allergie_repository.dart';

class UpdateAllergyEntry implements UseCase<Allergy, UpdateAllergieEntryParams> {
  final AllergiesRepository repository;
  UpdateAllergyEntry(this.repository);

  @override
  Future<Either<Failure, Allergy>> call(params) async {
    return await repository.updateAllergieEntry(id: params.id, title: params.title, body: params.body);
  }
}

class UpdateAllergieEntryParams {
  String id;
  String title;
  String body;

  UpdateAllergieEntryParams({required this.id, required this.title, required this.body});
}
