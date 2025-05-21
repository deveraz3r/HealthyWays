import 'package:fpdart/fpdart.dart';
import 'package:healthyways/core/common/entites/doctor_profile.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/core/usecase/usecase.dart';
import 'package:healthyways/features/doctor/domain/repositories/doctor_repository.dart';

class GetDoctorById implements UseCase<DoctorProfile, GetDoctorByIdParams> {
  final DoctorRepository repo;
  GetDoctorById(this.repo);

  @override
  Future<Either<Failure, DoctorProfile>> call(
    GetDoctorByIdParams params,
  ) async {
    return await repo.getDoctorById(params.uid);
  }
}

class GetDoctorByIdParams {
  String uid;
  GetDoctorByIdParams({required this.uid});
}
