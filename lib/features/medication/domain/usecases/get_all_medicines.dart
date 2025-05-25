import 'package:fpdart/fpdart.dart';
import 'package:healthyways/core/common/entites/medicine.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/core/usecase/usecase.dart';
import 'package:healthyways/features/medication/domain/repositories/medication_repository.dart';

class GetAllMedicines implements UseCase<List<Medicine>, NoParams> {
  final MedicationRepository medicationRepository;

  GetAllMedicines(this.medicationRepository);

  @override
  Future<Either<Failure, List<Medicine>>> call(params) async {
    return await medicationRepository.getAllMedicines();
  }
}
