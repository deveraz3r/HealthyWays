import 'package:fpdart/fpdart.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/core/usecase/usecase.dart';
import 'package:healthyways/core/common/entites/medication.dart';
import 'package:healthyways/features/medication/domain/repositories/medication_repository.dart';

class GetAllMedications implements UseCase<List<Medication>, NoParams> {
  final MedicationRepository medicationRepository;

  GetAllMedications(this.medicationRepository);

  @override
  Future<Either<Failure, List<Medication>>> call(params) async {
    return await medicationRepository.getAllMedications();
  }
}
