import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthyways/core/common/controllers/app_profile_controller.dart';
import 'package:healthyways/core/controller/controller_state_manager.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/core/usecase/usecase.dart';
import 'package:healthyways/features/measurements/domain/entites/measurement_entry.dart';
import 'package:healthyways/features/measurements/domain/entites/preset_measurement.dart';
import 'package:healthyways/features/measurements/domain/usecases/add_measurement_entry.dart';
import 'package:healthyways/features/measurements/domain/usecases/get_measurement_entries.dart';
import 'package:healthyways/features/measurements/domain/usecases/get_all_measurements.dart';
import 'package:healthyways/features/measurements/domain/usecases/get_my_measurement.dart';
import 'package:healthyways/features/measurements/domain/usecases/toggle_my_measurement_status.dart';

class MeasurementController extends GetxController {
  final GetAllMeasurements _getAllMeasurements;
  final GetMyMeasurements _getMyMeasurements;
  final ToggleMyMeasurementStatus _toggleMyMeasurementStatus;
  final GetMeasurementEntries _getMeasurementEntries;
  final AddMeasurementEntry _addMeasurementEntry;

  MeasurementController({
    required GetAllMeasurements getAllMeasurements,
    required GetMyMeasurements getMyMeasurements,
    required ToggleMyMeasurementStatus toggleMyMeasurementStatus,
    required GetMeasurementEntries getMeasurementEntries,
    required AddMeasurementEntry addMeasurementEntry,
  }) : _getAllMeasurements = getAllMeasurements,
       _getMyMeasurements = getMyMeasurements,
       _getMeasurementEntries = getMeasurementEntries,
       _addMeasurementEntry = addMeasurementEntry,
       _toggleMyMeasurementStatus = toggleMyMeasurementStatus;

  final allMeasurements = StateController<Failure, List<PresetMeasurement>>();
  final myMeasurements = StateController<Failure, List<PresetMeasurement>>();
  final measurementEnries = StateController<Failure, List<MeasurementEntry>>();

  Future<void> getAllMeasurements() async {
    allMeasurements.setLoading();

    final response = await _getAllMeasurements(NoParams());

    response.fold((failure) => allMeasurements.setError(failure), (success) => allMeasurements.setData(success));
  }

  Future<void> getMyMeasurements() async {
    myMeasurements.setLoading();

    final response = await _getMyMeasurements(NoParams());

    response.fold((failure) => myMeasurements.setError(failure), (success) => myMeasurements.setData(success));
  }

  Future<void> toggleMyMeasurementStatus({required String id}) async {
    final response = await _toggleMyMeasurementStatus(ToggleMyMeasurementStatusParams(id: id));

    response.fold((failure) => debugPrint("Toggled Measurement had error: ${failure.message}"), (success) {
      getMyMeasurements();
      // getAllMeasurements();
      debugPrint("Toggled Measurement succesfully");
    });
  }

  Future<void> getMeasurementEntries({required String patientId, required String measurementId}) async {
    measurementEnries.setLoading();

    final response = await _getMeasurementEntries(
      GetAllMeasurementEntriesParams(patientId: patientId, measurementId: measurementId),
    );

    response.fold((failure) => measurementEnries.setError(failure), (success) => measurementEnries.setData(success));
  }

  Future<void> addMeasurementEntry({required MeasurementEntry measurementEntry}) async {
    final response = await _addMeasurementEntry(AddMeasurementEntryParams(measurementEntry: measurementEntry));

    response.fold((failure) => debugPrint(failure.message), (success) {
      getMeasurementEntries(patientId: measurementEntry.patientId, measurementId: measurementEntry.measurementId);
      debugPrint("measurement added successfully");
    });
  }

  Rx<bool> isInMyMeasurements(String id) {
    return RxBool(myMeasurements.data?.any((measurement) => measurement.id == id) ?? false);
  }
}
