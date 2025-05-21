import 'package:fpdart/fpdart.dart';
import 'package:healthyways/core/common/entites/doctor_profile.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/core/usecase/usecase.dart';
import 'package:healthyways/features/doctor/domain/repositories/doctor_repository.dart';

class UpdateDoctorProfile implements UseCase<void, UpdateDoctorProfileParams> {
  final DoctorRepository repo;

  UpdateDoctorProfile(this.repo);

  @override
  Future<Either<Failure, void>> call(params) async {
    return await repo.updateDoctor(params.doctor);
  }
}

class UpdateDoctorProfileParams {
  DoctorProfile doctor;
  UpdateDoctorProfileParams({required this.doctor});
}
