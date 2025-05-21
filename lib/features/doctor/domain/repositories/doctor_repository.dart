import 'package:fpdart/fpdart.dart';
import 'package:healthyways/core/common/entites/doctor_profile.dart';
import 'package:healthyways/core/error/failure.dart';

abstract interface class DoctorRepository {
  Future<Either<Failure, DoctorProfile>> getDoctorById(String uid);
  Future<Either<Failure, void>> updateDoctor(DoctorProfile doctor);
  Future<Either<Failure, List<DoctorProfile>>> getAllDoctors();
}
