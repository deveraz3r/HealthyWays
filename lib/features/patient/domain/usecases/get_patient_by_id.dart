import 'package:fpdart/fpdart.dart';
import 'package:healthyways/core/common/entites/patient_profile.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/core/usecase/usecase.dart';
import 'package:healthyways/features/patient/domain/repositories/patient_repository.dart';

class GetPatientById implements UseCase<PatientProfile, GetPatientByIdParams> {
  final PatientRepository repository;

  GetPatientById(this.repository);

  @override
  Future<Either<Failure, PatientProfile>> call(GetPatientByIdParams params) {
    return repository.getPatientById(params.uid);
  }
}

class GetPatientByIdParams {
  final String uid;

  GetPatientByIdParams(this.uid);
}
