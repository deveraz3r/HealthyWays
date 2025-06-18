import 'package:fpdart/fpdart.dart';
import 'package:healthyways/core/usecase/usecase.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/core/common/entites/assigned_medication_report.dart';
import 'package:healthyways/features/medication/domain/repositories/medication_repository.dart';

class AddAssignedMedication implements UseCase<void, AddAssignedMedicationParams> {
  final MedicationRepository repository;

  AddAssignedMedication(this.repository);

  @override
  Future<Either<Failure, void>> call(AddAssignedMedicationParams params) {
    return repository.addAssignedMedication(params.assignedMedication);
  }
}

class AddAssignedMedicationParams {
  final AssignedMedicationReport assignedMedication;

  AddAssignedMedicationParams({required this.assignedMedication});
}
