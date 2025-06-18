import 'package:fpdart/fpdart.dart';
import 'package:healthyways/core/common/custom_types/visibility.dart';
import 'package:healthyways/core/common/entites/medication.dart';
import 'package:healthyways/core/common/entites/medicine.dart';
import 'package:healthyways/core/common/entites/patient_profile.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/features/measurements/domain/entites/measurement_entry.dart';

abstract class PatientRepository {
  Future<Either<Failure, PatientProfile>> getPatientById(String uid);
  Future<Either<Failure, void>> updatePatientProfile(PatientProfile profile);
  Future<Either<Failure, List<PatientProfile>>> getAllPatients();
  Future<Either<Failure, List<Medication>>> getAllMedications();
  Future<Either<Failure, void>> addMeasurementEntry({required MeasurementEntry measurementEntry});
  Future<Either<Failure, Medicine>> getMedicineById({required String id});
  Future<Either<Failure, List<MeasurementEntry>>> getMeasurementEntries({
    required String patientId,
    required String measurementId,
  });

  Future<Either<Failure, void>> toggleMedicationStatusById({required String id, DateTime? timeTaken});
  Future<Either<Failure, void>> updateVisibilitySettings({required String featureId, required Visibility visibility});
}
