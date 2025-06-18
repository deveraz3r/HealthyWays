import 'package:get/get.dart';
import 'package:healthyways/core/common/entites/medicine.dart';
import 'package:healthyways/core/controller/controller_state_manager.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/core/usecase/usecase.dart';
import 'package:healthyways/core/common/entites/medication.dart';
import 'package:healthyways/core/common/entites/assigned_medication_report.dart';
import 'package:healthyways/features/medication/domain/usecases/add_assigned_medication.dart';
import 'package:healthyways/features/medication/domain/usecases/get_all_medications.dart';
import 'package:healthyways/features/medication/domain/usecases/get_all_medicines.dart';
import 'package:healthyways/features/medication/domain/usecases/toggle_medication_status_by_id.dart';

class MedicationController extends GetxController {
  final GetAllMedicines _getAllMedicines;
  final GetAllMedications _getAllMedications;
  final ToggleMedicationStatusById _toggleMedicationStatusById;
  final AddAssignedMedication _addAssignedMedication;

  MedicationController({
    required GetAllMedicines getAllMedicines,
    required GetAllMedications getAllMedications,
    required ToggleMedicationStatusById toggleMedicationStatusById,
    required AddAssignedMedication addAssignedMedication,
  }) : _getAllMedicines = getAllMedicines,
       _getAllMedications = getAllMedications,
       _toggleMedicationStatusById = toggleMedicationStatusById,
       _addAssignedMedication = addAssignedMedication;

  final allMedicines = StateController<Failure, List<Medicine>>();
  final allMedications = StateController<Failure, List<Medication>>();

  Future<void> getAllMedicines() async {
    allMedicines.setLoading();

    final result = await _getAllMedicines(NoParams());

    result.fold((failure) => allMedicines.setError(failure), (success) => allMedicines.setData(success));
  }

  Future<void> getAllMedications() async {
    allMedications.setLoading();

    final result = await _getAllMedications(NoParams());

    result.fold((failure) => allMedications.setError(failure), (success) => allMedications.setData(success));
  }

  Future<void> toggleMedicationStatusById({required String id, DateTime? timeTaken}) async {
    final result = await _toggleMedicationStatusById(ToggleMedicationStatusParams(id: id, timeTaken: timeTaken));

    result.fold((failure) => allMedications.setError(failure), (_) => getAllMedications());
  }

  Future<void> assignMedication(AssignedMedicationReport assignedMedication) async {
    final result = await _addAssignedMedication(AddAssignedMedicationParams(assignedMedication: assignedMedication));
    result.fold(
      (failure) => Get.snackbar('Error', failure.message),
      (_) => Get.snackbar('Success', 'Medication assigned!'),
    );
  }
}
