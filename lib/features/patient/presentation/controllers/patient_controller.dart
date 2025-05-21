import 'package:get/get.dart';
import 'package:healthyways/core/common/entites/patient_profile.dart';
import 'package:healthyways/core/controller/controller_state_manager.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/core/usecase/usecase.dart';
import 'package:healthyways/features/patient/domain/usecases/get_all_patients.dart';
import 'package:healthyways/features/patient/domain/usecases/get_patient_by_id.dart';
import 'package:healthyways/features/patient/domain/usecases/update_patient_profile.dart';

class PatientController extends GetxController {
  final GetPatientById _getPatientById;
  final GetAllPatients _getAllPatients;
  final UpdatePatientProfile _updatePatientProfile;

  PatientController({
    required GetPatientById getPatientById,
    required GetAllPatients getAllPatients,
    required UpdatePatientProfile updatePatientProfile,
  }) : _getPatientById = getPatientById,
       _getAllPatients = getAllPatients,
       _updatePatientProfile = updatePatientProfile;

  final patient = StateController<Failure, PatientProfile>();
  final allPatients = StateController<Failure, List<PatientProfile>>();

  // ========================== Public Methods ===============================

  Future<void> getPatientById(String uid) async {
    patient.setLoading();

    final result = await _getPatientById(GetPatientByIdParams(uid));

    result.fold(
      (failure) => patient.setError(failure),
      (data) => patient.setData(data),
    );
  }

  Future<void> getAllPatients() async {
    allPatients.setLoading();

    final result = await _getAllPatients(NoParams());

    result.fold(
      (failure) => allPatients.setError(failure),
      (data) => allPatients.setData(data),
    );
  }

  Future<void> updatePatient(PatientProfile updatedProfile) async {
    patient.setLoading();

    final result = await _updatePatientProfile(updatedProfile);

    result.fold(
      (failure) => patient.setError(failure),
      (_) => patient.setData(updatedProfile), // Assume local update is valid
    );
  }
}
