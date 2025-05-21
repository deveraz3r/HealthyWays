import 'package:fpdart/fpdart.dart';
import 'package:healthyways/core/common/entites/patient_profile.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/core/usecase/usecase.dart';
import 'package:healthyways/features/patient/domain/repositories/patient_repository.dart';

class GetAllPatients implements UseCase<List<PatientProfile>, NoParams> {
  final PatientRepository repository;

  GetAllPatients(this.repository);

  @override
  Future<Either<Failure, List<PatientProfile>>> call(NoParams params) {
    return repository.getAllPatients();
  }
}
