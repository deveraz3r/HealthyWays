import 'package:fpdart/fpdart.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/core/usecase/usecase.dart';
import 'package:healthyways/features/allergies/domain/entities/allergy.dart';
import 'package:healthyways/features/allergies/domain/repositories/allergie_repository.dart';

class GetAllAllergyEntries
    implements UseCase<List<Allergy>, GetAllAllergyEntriesParams> {
  final AllergiesRepository repository;
  GetAllAllergyEntries(this.repository);

  @override
  Future<Either<Failure, List<Allergy>>> call(params) async {
    return await repository.getAllAllergieEntries(uid: params.uid);
  }
}

class GetAllAllergyEntriesParams {
  String uid;

  GetAllAllergyEntriesParams({required this.uid});
}
