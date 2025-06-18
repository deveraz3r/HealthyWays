import 'package:fpdart/fpdart.dart';
import 'package:healthyways/core/common/entites/medicine.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/core/usecase/usecase.dart';
import 'package:healthyways/features/patient/domain/repositories/patient_repository.dart';

class PatientGetMedicineById implements UseCase<Medicine, GetMedicineByIdParams> {
  final PatientRepository repository;

  PatientGetMedicineById(this.repository);

  @override
  Future<Either<Failure, Medicine>> call(GetMedicineByIdParams params) {
    return repository.getMedicineById(id: params.id);
  }
}

class GetMedicineByIdParams {
  final String id;
  GetMedicineByIdParams({required this.id});
}
