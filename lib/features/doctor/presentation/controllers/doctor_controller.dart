import 'package:get/get.dart';
import 'package:healthyways/core/common/entites/doctor_profile.dart';
import 'package:healthyways/core/controller/controller_state_manager.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/core/usecase/usecase.dart';
import 'package:healthyways/features/doctor/domain/usecases/get_all_doctors.dart';
import 'package:healthyways/features/doctor/domain/usecases/get_doctor_by_id.dart';
import 'package:healthyways/features/doctor/domain/usecases/update_doctor_profile.dart';

class DoctorController extends GetxController {
  final GetDoctorById _getDoctorById;
  final GetAllDoctors _getAllDoctors;
  final UpdateDoctorProfile _updateDoctorProfile;

  DoctorController({
    required GetDoctorById getDoctorById,
    required GetAllDoctors getAllDoctors,
    required UpdateDoctorProfile updateDoctorProfile,
  }) : _getDoctorById = getDoctorById,
       _getAllDoctors = getAllDoctors,
       _updateDoctorProfile = updateDoctorProfile;

  final doctor = StateController<Failure, DoctorProfile>();
  final allDoctors = StateController<Failure, List<DoctorProfile>>();

  // ========================== Public Methods ===============================

  Future<void> getDoctorById(String uid) async {
    doctor.setLoading();

    final result = await _getDoctorById(GetDoctorByIdParams(uid: uid));

    result.fold(
      (failure) => doctor.setError(failure),
      (data) => doctor.setData(data),
    );
  }

  Future<void> getAllDoctors() async {
    allDoctors.setLoading();

    final result = await _getAllDoctors(NoParams());

    result.fold(
      (failure) => allDoctors.setError(failure),
      (data) => allDoctors.setData(data),
    );
  }

  Future<void> updateDoctor(DoctorProfile updatedProfile) async {
    doctor.setLoading();

    final result = await _updateDoctorProfile(
      UpdateDoctorProfileParams(doctor: updatedProfile),
    );

    result.fold(
      (failure) => doctor.setError(failure),
      (_) => doctor.setData(updatedProfile), // Local update after success
    );
  }
}
