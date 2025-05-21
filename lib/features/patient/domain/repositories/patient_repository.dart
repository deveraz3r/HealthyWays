import 'package:fpdart/fpdart.dart';
import 'package:healthyways/core/common/entites/patient_profile.dart';
import 'package:healthyways/core/error/failure.dart';

abstract interface class PatientRepository {
  Future<Either<Failure, PatientProfile>> getPatientById(String uid);
  Future<Either<Failure, void>> updatePatientProfile(PatientProfile profile);
  Future<Either<Failure, List<PatientProfile>>> getAllPatients();
}
