import 'package:fpdart/fpdart.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/core/usecase/usecase.dart';
import 'package:healthyways/features/patient/domain/repositories/patient_repository.dart';

class PatientToggleMedicationStatusById implements UseCase<void, ToggleMedicationStatusParams> {
  final PatientRepository repository;

  PatientToggleMedicationStatusById(this.repository);

  @override
  Future<Either<Failure, void>> call(ToggleMedicationStatusParams params) async {
    return await repository.toggleMedicationStatusById(id: params.id, timeTaken: params.timeTaken);
  }
}

class ToggleMedicationStatusParams {
  final String id;
  final DateTime? timeTaken;

  ToggleMedicationStatusParams({required this.id, this.timeTaken});
}
