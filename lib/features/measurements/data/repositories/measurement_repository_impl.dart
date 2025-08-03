import 'package:fpdart/fpdart.dart';
import 'package:healthyways/core/common/custom_types/my_measurements.dart';
import 'package:healthyways/core/common/custom_types/visibility.dart';
import 'package:healthyways/core/common/entites/patient_profile.dart';
import 'package:healthyways/core/common/models/patient_profile_model.dart';
import 'package:healthyways/core/error/exceptions.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/features/measurements/data/datasources/measurement_remote_data_source.dart';
import 'package:healthyways/features/measurements/data/models/measurement_entry_model.dart';
import 'package:healthyways/features/measurements/domain/entites/measurement_entry.dart';
import 'package:healthyways/features/measurements/domain/entites/preset_measurement.dart';
import 'package:healthyways/features/measurements/domain/repositories/measurement_repository.dart';

class MeasurementRepositoryImpl implements MeasurementRepository {
  final MeasurementRemoteDataSource dataSource;
  MeasurementRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, List<PresetMeasurement>>> getAllMeasurements() async {
    try {
      final response = await dataSource.getAllMeasurements();

      return right(response);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<PresetMeasurement>>> getMyMeasurements({
    required PatientProfile patientProfile,
  }) async {
    try {
      final response = await dataSource.getMyMeasurements(
        patientProfile: PatientProfileModel.fromPatientProfile(patientProfile),
      );

      return right(response);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> toggleMyMeasurementStatus({
    required String id,
  }) async {
    try {
      await dataSource.toggleMyMeasurementStatus(measurementId: id);

      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<MeasurementEntry>>> getMeasurementEntries({
    required String patientId,
    required String measurementId,
  }) async {
    try {
      final response = await dataSource.getMeasurementEntries(
        patientId: patientId,
        measurementId: measurementId,
      );

      return right(response);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> addMeasurement({
    required MeasurementEntry measurementEntry,
  }) async {
    try {
      // Create a new MeasurementEntryModel from the MeasurementEntry
      final measurementModel = MeasurementEntryModel(
        id: measurementEntry.id,
        measurementId: measurementEntry.measurementId,
        patientId: measurementEntry.patientId,
        value: measurementEntry.value,
        note: measurementEntry.note,
        lastUpdated: measurementEntry.lastUpdated,
        createdAt: measurementEntry.createdAt,
      );

      await dataSource.addMeasurement(measurementEntry: measurementModel);
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, Visibility>> getMeasurementVisibility({
    required String measurementId,
  }) async {
    try {
      final response = await dataSource.getMeasurementVisibility(
        measurementId: measurementId,
      );

      return right(response);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> updateMeasurementVisibility({
    required String measurementId,
    required Visibility visibility,
  }) async {
    try {
      await dataSource.updateMeasurementVisibility(
        measurementId: measurementId,
        visibility: visibility,
      );

      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> updateMyMeasurementReminderSettings({
    required MyMeasurements myMeasurement,
  }) async {
    try {
      await dataSource.updateMyMeasurementReminderSettings(
        myMeasurement: myMeasurement,
      );

      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
