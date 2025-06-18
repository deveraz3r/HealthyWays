import 'package:fpdart/fpdart.dart';
import 'package:healthyways/core/common/entites/medication.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/core/usecase/usecase.dart';
import 'package:healthyways/features/patient/domain/repositories/patient_repository.dart';

class PatientGetAllMedications implements UseCase<List<Medication>, NoParams> {
  final PatientRepository repository;

  PatientGetAllMedications(this.repository);

  @override
  Future<Either<Failure, List<Medication>>> call(NoParams params) async {
    return await repository.getAllMedications();
  }
}
