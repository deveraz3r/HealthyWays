import 'package:fpdart/fpdart.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/features/allergies/domain/entities/allergy.dart';

abstract class AllergiesRepository {
  Future<Either<Failure, List<Allergy>>> getAllAllergieEntries();
  Future<Either<Failure, void>> createAllergieEntry(Allergy allergie);
  Future<Either<Failure, void>> deleteAllergieEntry(String id);
  Future<Either<Failure, Allergy>> updateAllergieEntry({
    required String id,
    required String title,
    required String body,
  });
}
