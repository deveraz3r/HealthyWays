import 'package:fpdart/fpdart.dart';
import 'package:healthyways/core/common/entites/medicine.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/core/common/entites/medication.dart';

abstract interface class MedicationRepository {
  Future<Either<Failure, List<Medicine>>> getAllMedicines();
  Future<Either<Failure, List<Medication>>> getAllMedications();
  Future<Either<Failure, void>> toggleMedicationStatusById({
    required String id,
    DateTime? timeTaken,
  });
}
