import 'package:fpdart/fpdart.dart';
import 'package:healthyways/core/common/entites/doctor_profile.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/features/doctor/data/datasources/doctor_remote_data_source.dart';
import 'package:healthyways/core/common/models/doctor_profile_model.dart';
import 'package:healthyways/features/doctor/domain/repositories/doctor_repository.dart';

class DoctorRepositoryImpl implements DoctorRepository {
  final DoctorRemoteDataSource remoteDataSource;
  DoctorRepositoryImpl(this.remoteDataSource);

  // @override
  // Future<Either<Failure, void>> addMyPatient(String patientId) async {
  //   try {
  //     await remoteDataSource.addMyPatient(patientId);
  //     return const Right(null);
  //   } catch (e) {
  //     return Left(Failure(e.toString()));
  //   }
  // }

  @override
  Future<Either<Failure, DoctorProfile>> getDoctorById(String uid) async {
    try {
      final doctor = await remoteDataSource.getDoctorProfileById(uid);

      if (doctor == null) return Left(Failure("Doctor not found"));

      return Right(doctor!);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateDoctor(DoctorProfile doctor) async {
    try {
      await remoteDataSource.updateDoctorProfile(DoctorProfileModel.fromEntity(doctor));
      return const Right(null); //Null means succesful
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<DoctorProfile>>> getAllDoctors() async {
    try {
      final doctors = await remoteDataSource.getAllDoctors();
      if (doctors.isEmpty) {
        return Right([]); // Return empty list instead of throwing error
      }
      return Right(doctors);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
