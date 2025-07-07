import 'package:fpdart/fpdart.dart';
import 'package:healthyways/core/common/custom_types/visibility.dart';
import 'package:healthyways/core/common/entites/medicine.dart';
import 'package:healthyways/core/common/entites/patient_profile.dart';
import 'package:healthyways/core/error/exceptions.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/features/measurements/data/models/measurement_entry_model.dart';
import 'package:healthyways/features/measurements/domain/entites/measurement_entry.dart';
import 'package:healthyways/features/patient/data/datasources/patient_remote_data_source.dart';
import 'package:healthyways/core/common/models/patient_profile_model.dart';
import 'package:healthyways/features/patient/domain/repositories/patient_repository.dart';
import 'package:healthyways/core/common/entites/medication.dart';

class PatientRepositoryImpl implements PatientRepository {
  final PatientRemoteDataSource remoteDataSource;

  const PatientRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, PatientProfile>> getPatientById(String uid) async {
    try {
      final patient = await remoteDataSource.getPatientProfileById(uid);
      if (patient == null) {
        return Left(Failure("Patient not found"));
      }
      return Right(patient);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> updatePatientProfile(PatientProfile profile) async {
    try {
      await remoteDataSource.updatePatientProfile(profile as PatientProfileModel);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<PatientProfile>>> getAllPatients() async {
    try {
      final patients = await remoteDataSource.getAllPatients();
      return Right(patients);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> updateVisibilitySettings({
    required String featureId,
    required Visibility visibility,
  }) async {
    try {
      await remoteDataSource.updateVisibilitySettings(featureId: featureId, visibility: visibility);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Medication>>> getAllMedications() async {
    try {
      final medications = await remoteDataSource.getAllMedications();
      return Right(medications);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> addMeasurementEntry({required MeasurementEntry measurementEntry}) async {
    try {
      final measurementModel = MeasurementEntryModel(
        id: measurementEntry.id,
        measurementId: measurementEntry.measurementId,
        patientId: measurementEntry.patientId,
        value: measurementEntry.value,
        note: measurementEntry.note,
        lastUpdated: measurementEntry.lastUpdated,
        createdAt: measurementEntry.createdAt,
      );

      await remoteDataSource.addMeasurementEntry(measurementEntry: measurementModel);
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, Medicine>> getMedicineById({required String id}) async {
    try {
      final medicine = await remoteDataSource.getMedicineById(id: id);
      return Right(medicine);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> toggleMedicationStatusById({required String id, DateTime? timeTaken}) async {
    try {
      await remoteDataSource.toggleMedicationStatusById(id: id, timeTaken: timeTaken);
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
      final response = await remoteDataSource.getMeasurementEntries(patientId: patientId, measurementId: measurementId);

      return right(response);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getMyProviders() async {
    try {
      final providers = await remoteDataSource.getMyProviders();
      return Right(providers);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> addMyProvider(String providerId) async {
    try {
      await remoteDataSource.addMyProvider(providerId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> removeMyProvider(String providerId) async {
    try {
      await remoteDataSource.removeMyProvider(providerId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }
}
