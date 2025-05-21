import 'package:fpdart/fpdart.dart';
import 'package:healthyways/core/common/entites/doctor_profile.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/core/usecase/usecase.dart';
import 'package:healthyways/features/doctor/domain/repositories/doctor_repository.dart';

class GetAllDoctors implements UseCase<List<DoctorProfile>, NoParams> {
  final DoctorRepository repo;
  GetAllDoctors(this.repo);

  @override
  Future<Either<Failure, List<DoctorProfile>>> call(NoParams params) async {
    return await repo.getAllDoctors();
  }
}
