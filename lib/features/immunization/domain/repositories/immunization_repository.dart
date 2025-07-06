import 'package:fpdart/fpdart.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/features/immunization/domain/entities/immunization.dart';

abstract class ImmunizationRepository {
  Future<Either<Failure, List<Immunization>>> getAllImmunizationEntries();
  Future<Either<Failure, void>> createImmunizationEntry(Immunization immunization);
  Future<Either<Failure, void>> deleteImmunizationEntry(String id);
  Future<Either<Failure, Immunization>> updateImmunizationEntry({
    required String id,
    required String title,
    required String body,
  });
}
