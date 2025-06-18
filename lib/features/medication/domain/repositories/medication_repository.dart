import 'package:fpdart/fpdart.dart';
import 'package:healthyways/core/common/entites/medicine.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/core/common/entites/medication.dart';
import 'package:healthyways/core/common/entites/assigned_medication_report.dart';

abstract interface class MedicationRepository {
  Future<Either<Failure, List<Medicine>>> getAllMedicines();
  Future<Either<Failure, List<Medication>>> getAllMedications();
  Future<Either<Failure, Medicine>> getMedicineById({required String id});
  Future<Either<Failure, void>> toggleMedicationStatusById({required String id, DateTime? timeTaken});
  Future<Either<Failure, void>> addAssignedMedication(AssignedMedicationReport assignedMedication);
}
