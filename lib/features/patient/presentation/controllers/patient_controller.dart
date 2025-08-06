import 'package:get/get.dart';
import 'package:healthyways/core/common/controllers/app_profile_controller.dart';
import 'package:healthyways/core/common/custom_types/visibility.dart';
import 'package:healthyways/core/common/entites/medication.dart';
import 'package:healthyways/core/common/entites/medicine.dart';
import 'package:healthyways/core/common/entites/patient_profile.dart';
import 'package:healthyways/core/controller/controller_state_manager.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/core/usecase/usecase.dart';
import 'package:healthyways/features/auth/presentation/controller/auth_controller.dart';
import 'package:healthyways/features/measurements/domain/entites/measurement_entry.dart';
import 'package:healthyways/features/patient/domain/usecases/add_measurement_entry.dart';
import 'package:healthyways/features/patient/domain/usecases/add_my_provider.dart';
import 'package:healthyways/features/patient/domain/usecases/get_all_patients.dart';
import 'package:healthyways/features/patient/domain/usecases/get_medicine_by_id.dart';
import 'package:healthyways/features/patient/domain/usecases/get_my_providers.dart';
import 'package:healthyways/features/patient/domain/usecases/get_patient_by_id.dart';
import 'package:healthyways/features/patient/domain/usecases/patient_get_all_medications.dart';
import 'package:healthyways/features/patient/domain/usecases/patient_get_measurement_entries.dart';
import 'package:healthyways/features/patient/domain/usecases/remove_my_provider.dart';
import 'package:healthyways/features/patient/domain/usecases/toggle_medication_status_by_id.dart';
import 'package:healthyways/features/patient/domain/usecases/update_patient_profile.dart';
import 'package:healthyways/features/patient/domain/usecases/update_visibility_settings.dart';
import 'package:healthyways/features/permission_requests/presentation/controllers/premission_request_controller.dart';

class PatientController extends GetxController {
  final GetPatientById _getPatientById;
  final GetAllPatients _getAllPatients;
  final UpdatePatientProfile _updatePatientProfile;
  final UpdateVisibilitySettings _updateVisibilitySettings;
  final PatientGetAllMedications _getAllMedications;
  final AddMeasurementEntry _addMeasurementEntry;
  final PatientGetMedicineById _getMedicineById;
  final PatientToggleMedicationStatusById _toggleMedicationStatusById;
  final PatientGetMeasurementEntries _patientGetMeasurementEntries;

  final GetMyProviders _getMyProviders;
  final AddMyProvider _addMyProvider;
  final RemoveMyProvider _removeMyProvider;

  PatientController({
    required GetPatientById getPatientById,
    required GetAllPatients getAllPatients,
    required UpdatePatientProfile updatePatientProfile,
    required UpdateVisibilitySettings updateVisibilitySettings,
    required PatientGetAllMedications getAllMedications,
    required AddMeasurementEntry addMeasurementEntry,
    required PatientGetMedicineById getMedicineById,
    required PatientToggleMedicationStatusById toggleMedicationStatusById,
    required PatientGetMeasurementEntries patientGetMeasurementEntries,

    required GetMyProviders getMyProviders,
    required AddMyProvider addMyProvider,
    required RemoveMyProvider removeMyProvider,
  }) : _getPatientById = getPatientById,
       _getAllPatients = getAllPatients,
       _updatePatientProfile = updatePatientProfile,
       _updateVisibilitySettings = updateVisibilitySettings,
       _getAllMedications = getAllMedications,
       _addMeasurementEntry = addMeasurementEntry,
       _getMedicineById = getMedicineById,
       _toggleMedicationStatusById = toggleMedicationStatusById,
       _patientGetMeasurementEntries = patientGetMeasurementEntries,
       _getMyProviders = getMyProviders,
       _addMyProvider = addMyProvider,
       _removeMyProvider = removeMyProvider;

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  final patient = StateController<Failure, PatientProfile>();
  final allPatients = StateController<Failure, List<PatientProfile>>();
  final patientMedications = StateController<Failure, List<Medication>>();
  final myProviders = StateController<Failure, List<String>>();

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

  Future<void> updateVisibilitySettings({
    required String featureId,
    required Visibility visibility,
  }) async {
    final response = await _updateVisibilitySettings(
      UpdateVisibilitySettingsParams(
        featureId: featureId,
        visibility: visibility,
      ),
    );

    response.fold(
      (failure) => Get.snackbar(
        'Error',
        'Failed to update visibility settings: ${failure.message}',
        snackPosition: SnackPosition.BOTTOM,
      ),
      (_) => Get.snackbar(
        'Success',
        'Visibility settings updated successfully',
        snackPosition: SnackPosition.BOTTOM,
      ),
    );
  }

  void getMyMeasurements() {
    final myMeasurements = patient.data!.myMeasurements;
  }

  Future<void> getAllMedications() async {
    patientMedications.setLoading();

    final result = await _getAllMedications(NoParams());

    result.fold(
      (failure) => patientMedications.setError(failure),
      (success) => patientMedications.setData(success),
    );
  }

  Future<void> addMeasurementEntry({
    required MeasurementEntry measurementEntry,
  }) async {
    final response = await _addMeasurementEntry(
      AddMeasurementEntryParams(measurementEntry: measurementEntry),
    );

    response.fold(
      (failure) {
        print("Failed to add measurement entry: ${failure.message}");
        Get.snackbar(
          'Error',
          'Failed to add measurement',
          snackPosition: SnackPosition.BOTTOM,
        );
      },
      (success) {
        print("Measurement entry added successfully");
        Get.snackbar(
          'Success',
          'Measurement added successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      },
    );
  }

  // Add cache for medicines
  final _medicineCache = <String, Medicine>{}.obs;

  Future<Medicine?> getMedicineById(String id) async {
    // Check cache first
    if (_medicineCache.containsKey(id)) {
      return _medicineCache[id];
    }

    final response = await _getMedicineById(GetMedicineByIdParams(id: id));

    return response.fold(
      (failure) {
        print("Failed to get medicine: ${failure.message}");
        return null;
      },
      (medicine) {
        _medicineCache[id] = medicine;
        return medicine;
      },
    );
  }

  Future<void> toggleMedicationStatusById({
    required String id,
    DateTime? timeTaken,
    required Medication medication, // Add medication parameter
  }) async {
    // Update local state first
    final updatedMedications =
        patientMedications.data?.map((med) {
          if (med.id == id) {
            return Medication(
              id: med.id,
              medicineId: med.medicineId,
              assignedTo: med.assignedTo,
              assignedBy: med.assignedBy,
              isActive: med.isActive,
              quantity: med.quantity,
              allocatedTime: med.allocatedTime,
              isTaken:
                  timeTaken != null, // If timeTaken is null, mark as not taken
              takenTime: timeTaken,
            );
          }
          return med;
        }).toList();

    if (updatedMedications != null) {
      patientMedications.setData(updatedMedications);
    }

    // Update database in background
    final result = await _toggleMedicationStatusById(
      ToggleMedicationStatusParams(id: id, timeTaken: timeTaken),
    );

    result.fold(
      (failure) {
        Get.snackbar(
          'Error',
          'Failed to update medication status',
          snackPosition: SnackPosition.BOTTOM,
        );
        // Revert local state on error
        if (updatedMedications != null) {
          patientMedications.setData(
            updatedMedications.map((med) {
              if (med.id == id) {
                return medication; // Revert to original state
              }
              return med;
            }).toList(),
          );
        }
      },
      (_) {
        Get.snackbar(
          'Success',
          'Medication marked as ${timeTaken != null ? 'taken' : 'not taken'}',
          snackPosition: SnackPosition.BOTTOM,
        );
      },
    );
  }

  Future<List<MeasurementEntry>> getMeasurementEntries({
    required String patientId,
    required String measurementId,
  }) async {
    try {
      final entries = await _patientGetMeasurementEntries(
        PatientGetMeasurementEntriesParams(
          patientId: patientId,
          measurementId: measurementId,
        ),
      );

      return entries.fold((failure) {
        print("Failed to get entries: ${failure.message}");
        return [];
      }, (entries) => entries);
    } catch (e) {
      print("Error getting entries: $e");
      return [];
    }
  }

  Future<void> getMyProviders() async {
    myProviders.setLoading();
    final result = await _getMyProviders(NoParams());
    result.fold(
      (failure) => myProviders.setError(failure),
      (providers) => myProviders.setData(providers),
    );
  }

  Future<void> addMyProvider(String providerId) async {
    try {
      // final result = await _addMyProvider(AddMyProviderParams(providerId: providerId));
      final currentPatient = Get.find<AppProfileController>().profile.data!;
      await Get.find<PermissionRequestController>().createRequest(
        patientId: currentPatient.uid,
        providerId: providerId,
        createdByRole: currentPatient.selectedRole,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add provider: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> removeMyProvider(String providerId) async {
    final result = await _removeMyProvider(
      RemoveMyProviderParams(providerId: providerId),
    );
    result.fold(
      (failure) => Get.snackbar(
        'Error',
        'Failed to remove provider: ${failure.message}',
        snackPosition: SnackPosition.BOTTOM,
      ),
      (_) {
        Get.snackbar(
          'Success',
          'Provider removed successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
        getMyProviders(); // Refresh the list
      },
    );
  }
}
