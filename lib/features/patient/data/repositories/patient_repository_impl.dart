import 'package:fpdart/fpdart.dart';
import 'package:healthyways/core/common/entites/patient_profile.dart';
import 'package:healthyways/core/error/exceptions.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/features/patient/data/datasources/patient_remote_data_source.dart';
import 'package:healthyways/core/common/models/patient_profile_model.dart';
import 'package:healthyways/features/patient/domain/repositories/patient_repository.dart';

class PatientRepositoryImpl implements PatientRepository {
  final PatientRemoteDataSource remoteDataSource;
  PatientRepositoryImpl(this.remoteDataSource);

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
}
