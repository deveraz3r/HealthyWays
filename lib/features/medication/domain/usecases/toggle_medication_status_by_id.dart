import 'package:fpdart/fpdart.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/core/usecase/usecase.dart';
import 'package:healthyways/features/medication/domain/repositories/medication_repository.dart';

class ToggleMedicationStatusById
    implements UseCase<void, ToggleMedicationStatusParams> {
  final MedicationRepository medicationRepository;

  ToggleMedicationStatusById(this.medicationRepository);

  @override
  Future<Either<Failure, void>> call(
    ToggleMedicationStatusParams params,
  ) async {
    return await medicationRepository.toggleMedicationStatusById(
      id: params.id,
      timeTaken: params.timeTaken,
    );
  }
}

class ToggleMedicationStatusParams {
  final String id;
  final DateTime? timeTaken;

  ToggleMedicationStatusParams({required this.id, this.timeTaken});
}
