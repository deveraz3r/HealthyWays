import 'package:fpdart/fpdart.dart';
import 'package:healthyways/core/common/custom_types/my_measurements.dart';
import 'package:healthyways/core/common/custom_types/visibility.dart';
import 'package:healthyways/core/common/entites/patient_profile.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/features/measurements/domain/entites/measurement_entry.dart';
import 'package:healthyways/features/measurements/domain/entites/preset_measurement.dart';

abstract interface class MeasurementRepository {
  Future<Either<Failure, List<PresetMeasurement>>> getAllMeasurements();
  Future<Either<Failure, List<PresetMeasurement>>> getMyMeasurements({
    required PatientProfile patientProfile,
  });
  Future<Either<Failure, List<MeasurementEntry>>> getMeasurementEntries({
    required String patientId,
    required String measurementId,
  });
  Future<Either<Failure, void>> addMeasurement({
    required MeasurementEntry measurementEntry,
  });
  Future<Either<Failure, void>> toggleMyMeasurementStatus({required String id});
  Future<Either<Failure, void>> updateMyMeasurementReminderSettings({
    required MyMeasurements myMeasurement,
  });

  Future<Either<Failure, Visibility>> getMeasurementVisibility({
    required String measurementId,
  });
  Future<Either<Failure, void>> updateMeasurementVisibility({
    required String measurementId,
    required Visibility visibility,
  });
}
