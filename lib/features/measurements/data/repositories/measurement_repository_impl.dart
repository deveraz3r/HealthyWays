import 'package:fpdart/fpdart.dart';
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
  Future<Either<Failure, List<PresetMeasurement>>> getMyMeasurements() async {
    try {
      final response = await dataSource.getMyMeasurements();

      return right(response);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> toggleMyMeasurementStatus({required String id}) async {
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
      final response = await dataSource.getMeasurementEntries(patientId: patientId, measurementId: measurementId);

      print("MEasuremetn entries: $response");

      return right(response);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> addMeasurement({required MeasurementEntry measurementEntry}) async {
    try {
      // Create a new MeasurementEntryModel from the MeasurementEntry
      final measurementModel = MeasurementEntryModel(
        id: measurementEntry.id,
        measurementId: measurementEntry.measurementId,
        patientId: measurementEntry.patientId,
        value: measurementEntry.value,
        note: measurementEntry.note,
        lastUpdated: measurementEntry.lastUpdated,
      );

      await dataSource.addMeasurement(measurementEntry: measurementModel);
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
