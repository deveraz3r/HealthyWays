import 'package:get/get.dart';
import 'package:healthyways/core/common/controllers/app_profile_controller.dart';
import 'package:healthyways/core/common/custom_types/my_measurements.dart';
import 'package:healthyways/core/common/custom_types/visibility.dart';
import 'package:healthyways/core/common/custom_types/visibility_type.dart';
import 'package:healthyways/core/common/entites/patient_profile.dart';
import 'package:healthyways/core/controller/controller_state_manager.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/core/usecase/usecase.dart';
import 'package:healthyways/features/measurements/domain/entites/measurement_entry.dart';
import 'package:healthyways/features/measurements/domain/entites/preset_measurement.dart';
import 'package:healthyways/features/measurements/domain/usecases/add_measurement_entry.dart';
import 'package:healthyways/features/measurements/domain/usecases/get_measurement_entries.dart';
import 'package:healthyways/features/measurements/domain/usecases/get_all_measurements.dart';
import 'package:healthyways/features/measurements/domain/usecases/get_measurement_visibility.dart';
import 'package:healthyways/features/measurements/domain/usecases/get_my_measurement.dart';
import 'package:healthyways/features/measurements/domain/usecases/toggle_my_measurement_status.dart';
import 'package:healthyways/features/measurements/domain/usecases/update_measurement_visibility.dart';
import 'package:healthyways/features/measurements/domain/usecases/update_my_measurement_reminder_settings.dart';

class MeasurementController extends GetxController {
  final GetAllMeasurements _getAllMeasurements;
  final GetMyMeasurements _getMyMeasurements;
  final ToggleMyMeasurementStatus _toggleMyMeasurementStatus;
  final GetMeasurementEntries _getMeasurementEntries;
  final AddMeasurementEntry _addMeasurementEntry;
  final GetMeasurementVisibility _getMeasurementVisibility;
  final UpdateMeasurementVisibility _updateMeasurementVisibility;
  final AppProfileController _appProfileController;
  final UpdateMyMeasurementReminderSettings _updateMyMeasurementReminderSettings;

  MeasurementController({
    required GetAllMeasurements getAllMeasurements,
    required GetMyMeasurements getMyMeasurements,
    required ToggleMyMeasurementStatus toggleMyMeasurementStatus,
    required GetMeasurementEntries getMeasurementEntries,
    required AddMeasurementEntry addMeasurementEntry,
    required GetMeasurementVisibility getMeasurementVisibility,
    required UpdateMeasurementVisibility updateMeasurementVisibility,
    required AppProfileController appProfileController,
    required UpdateMyMeasurementReminderSettings updateMyMeasurementReminderSettings,
  }) : _getAllMeasurements = getAllMeasurements,
       _getMyMeasurements = getMyMeasurements,
       _getMeasurementEntries = getMeasurementEntries,
       _addMeasurementEntry = addMeasurementEntry,
       _toggleMyMeasurementStatus = toggleMyMeasurementStatus,
       _getMeasurementVisibility = getMeasurementVisibility,
       _updateMeasurementVisibility = updateMeasurementVisibility,
       _appProfileController = appProfileController,
       _updateMyMeasurementReminderSettings = updateMyMeasurementReminderSettings;

  final allMeasurements = StateController<Failure, List<PresetMeasurement>>();
  final myMeasurements = StateController<Failure, List<PresetMeasurement>>();
  final measurementEntries = StateController<Failure, List<MeasurementEntry>>();

  Future<void> getAllMeasurements() async {
    allMeasurements.setLoading();

    final response = await _getAllMeasurements(NoParams());

    response.fold((failure) => allMeasurements.setError(failure), (success) => allMeasurements.setData(success));
  }

  Future<void> getMyMeasurements() async {
    myMeasurements.setLoading();

    final response = await _getMyMeasurements(NoParams());

    response.fold((failure) => myMeasurements.setError(failure), (success) {
      myMeasurements.setData(success);
    });
  }

  Future<void> toggleMyMeasurementStatus({required String id}) async {
    final response = await _toggleMyMeasurementStatus(ToggleMyMeasurementStatusParams(id: id));

    response.fold((failure) => print("Toggled Measurement had error: ${failure.message}"), (success) {
      getMyMeasurements();
      // getAllMeasurements();
      print("Toggled Measurement succesfully");
    });
  }

  Future<void> getMeasurementEntries({required String patientId, required String measurementId}) async {
    measurementEntries.setLoading();

    final response = await _getMeasurementEntries(
      GetAllMeasurementEntriesParams(patientId: patientId, measurementId: measurementId),
    );

    response.fold((failure) => measurementEntries.setError(failure), (success) => measurementEntries.setData(success));
  }

  Future<void> addMeasurementEntry({required MeasurementEntry measurementEntry}) async {
    final response = await _addMeasurementEntry(AddMeasurementEntryParams(measurementEntry: measurementEntry));

    response.fold((failure) => print(failure.message), (success) {
      getMeasurementEntries(patientId: measurementEntry.patientId, measurementId: measurementEntry.measurementId);
      print("measurement added successfully");
    });
  }

  Rx<bool> isInMyMeasurements(String id) {
    return RxBool(myMeasurements.data?.any((measurement) => measurement.id == id) ?? false);
  }

  final measurementVisibility = StateController<Failure, Visibility>();

  Future<void> updateMeasurementVisibility({required String measurementId}) async {
    final response = await _updateMeasurementVisibility(
      UpdateMeasurementVisibilityParams(
        measurementId: measurementId,
        visibility: measurementVisibility.data ?? Visibility(type: VisibilityType.global, customAccess: []),
      ),
    );

    response.fold(
      (failure) {
        print("Failed to update measurement visibility: ${failure.message}");
        Get.snackbar('Error', 'Failed to update visibility settings', snackPosition: SnackPosition.BOTTOM);
      },
      (success) {
        print("Measurement visibility updated successfully");
        // Refresh measurements to get updated state
        getMyMeasurements();
        Get.snackbar('Success', 'Visibility settings updated', snackPosition: SnackPosition.BOTTOM);
      },
    );
  }

  Future<void> getMeasurementVisibility({required String measurementId}) async {
    measurementVisibility.setLoading();

    final response = await _getMeasurementVisibility(GetMeasurementVisibilityParams(measurementId: measurementId));

    response.fold(
      (failure) {
        measurementVisibility.setError(failure);
        print("Failed to get measurement visibility: ${failure.message}");
        Get.snackbar('Error', 'Failed to load visibility settings', snackPosition: SnackPosition.BOTTOM);
      },
      (visibility) {
        measurementVisibility.setData(visibility);
      },
    );
  }

  Future<void> updateMyMeasurementReminderSettings({required MyMeasurements myMeasurement}) async {
    final response = await _updateMyMeasurementReminderSettings(
      UpdateMyMeasurementReminderSettingsParams(myMeasurement: myMeasurement),
    );

    response.fold(
      (failure) {
        print("Failed to update reminder settings: ${failure.message}");
        Get.snackbar('Error', 'Failed to update reminder settings', snackPosition: SnackPosition.BOTTOM);
      },
      (success) {
        print("Measurement reminder settings updated successfully");
        // Refresh measurements to get updated state
        getMyMeasurements();
        Get.snackbar('Success', 'Reminder settings updated', snackPosition: SnackPosition.BOTTOM);
      },
    );
  }

  RxBool isGlobalVisiblity() {
    return ((_appProfileController.profile.data as PatientProfile).globalVisibility.type == VisibilityType.global).obs;
  }

  // Add to MeasurementController
  MyMeasurements? getCurrentMeasurementSettings(String measurementId) {
    final profile = _appProfileController.profile.data as PatientProfile;
    try {
      return profile.myMeasurements.firstWhere((m) => m.id == measurementId);
    } catch (e) {
      return null;
    }
  }
}
