import 'package:fpdart/fpdart.dart';
import 'package:healthyways/core/common/entites/patient_profile.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/core/usecase/usecase.dart';
import 'package:healthyways/features/patient/domain/repositories/patient_repository.dart';

class UpdatePatientProfile implements UseCase<void, PatientProfile> {
  final PatientRepository repository;

  UpdatePatientProfile(this.repository);

  @override
  Future<Either<Failure, void>> call(PatientProfile profile) {
    return repository.updatePatientProfile(profile);
  }
}
