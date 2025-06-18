import 'package:get/get.dart';
import 'package:healthyways/core/common/entites/assigned_medication_report.dart';
import 'package:healthyways/core/common/entites/medicine.dart';
import 'package:healthyways/core/common/entites/patient_profile.dart';
import 'package:healthyways/core/controller/controller_state_manager.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/core/usecase/usecase.dart';
import 'package:healthyways/features/medication/domain/usecases/get_medicine_by_id.dart';
import 'package:healthyways/features/patient/domain/usecases/get_patient_by_id.dart';
import 'package:healthyways/features/updates/domain/usecases/get_all_medication_schedule_report.dart';

class UpdatesController extends GetxController {
  final GetAllMedicationScheduleReport _getAllMedicationScheduleReport;
  final GetPatientById _getPatientById;
  final GetMedicineById _getMedicineById;

  UpdatesController({
    required GetAllMedicationScheduleReport getAllMedicationScheduleReport,
    required GetPatientById getPatientById,
    required GetMedicineById getMedicineById,
  }) : _getAllMedicationScheduleReport = getAllMedicationScheduleReport,
       _getPatientById = getPatientById,
       _getMedicineById = getMedicineById;

  final allMedicationScheduleReport = StateController<Failure, List<AssignedMedicationReport>>();

  Future<void> getAllMedicationScheduleReports() async {
    allMedicationScheduleReport.setLoading();

    final result = await _getAllMedicationScheduleReport(NoParams());

    result.fold(
      (failure) => allMedicationScheduleReport.setError(failure),
      (success) => allMedicationScheduleReport.setData(success),
    );
  }

  Future<PatientProfile> getPatientById({required String id}) async {
    final response = await _getPatientById(GetPatientByIdParams(id));

    return response.fold((error) {
      // Use a logging framework instead of print
      Get.log('Error: ${error.message}', isError: true);
      throw Exception(error.message);
    }, (success) => success);
  }

  Future<Medicine> getMedicineById({required String id}) async {
    final response = await _getMedicineById(GetMedicineByIdParams(id: id));

    return response.fold((error) {
      // Use a logging framework instead of print
      Get.log('Error: ${error.message}', isError: true);
      throw Exception(error.message);
    }, (success) => success);
  }
}
