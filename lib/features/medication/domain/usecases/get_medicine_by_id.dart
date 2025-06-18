import 'package:fpdart/fpdart.dart';
import 'package:healthyways/core/common/entites/medicine.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/core/usecase/usecase.dart';
import 'package:healthyways/features/medication/domain/repositories/medication_repository.dart';

class GetMedicineById implements UseCase<Medicine, GetMedicineByIdParams> {
  final MedicationRepository medicationRepository;

  GetMedicineById(this.medicationRepository);

  @override
  Future<Either<Failure, Medicine>> call(params) async {
    return await medicationRepository.getMedicineById(id: params.id);
  }
}

class GetMedicineByIdParams {
  String id;

  GetMedicineByIdParams({required this.id});
}
