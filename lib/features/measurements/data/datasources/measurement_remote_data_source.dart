import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' as material;
import 'package:healthyways/core/common/custom_types/repetition_type.dart';
import 'package:healthyways/core/constants/supabase/patients_table_columns.dart';
import 'package:healthyways/core/constants/supabase/supabase_tables.dart';
import 'package:healthyways/features/measurements/data/models/measurement_entry_model.dart';
import 'package:healthyways/features/measurements/data/models/preset_measurement_model.dart';
import 'package:healthyways/features/measurements/domain/entites/measurement_entry.dart';
import 'package:healthyways/core/common/controllers/app_profile_controller.dart';
import 'package:healthyways/core/common/custom_types/my_measurements.dart';
import 'package:healthyways/core/common/custom_types/visibility.dart';
import 'package:healthyways/core/common/custom_types/visibility_type.dart';
import 'package:healthyways/core/common/models/patient_profile_model.dart';
import 'package:healthyways/core/error/exceptions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:healthyways/core/common/entites/patient_profile.dart' as p;

abstract interface class MeasurementRemoteDataSource {
  Future<List<PresetMeasurementModel>> getAllMeasurements();
  Future<List<PresetMeasurementModel>> getMyMeasurements();
  Future<List<MeasurementEntry>> getMeasurementEntries({required String patientId, required String measurementId});
  Future<void> addMeasurement({required MeasurementEntryModel measurementEntry});
  Future<void> toggleMyMeasurementStatus({required String measurementId});

  Future<void> updateMyMeasurementReminderSettings({required MyMeasurements myMeasurement});

  //Visibility
  Future<Visibility> getMeasurementVisibility({required String measurementId});
  Future<void> updateMeasurementVisibility({required String measurementId, required Visibility visibility});
}

class MeasurementRemoteDataSourceImpl implements MeasurementRemoteDataSource {
  final SupabaseClient supabaseClient;
  final AppProfileController appProfileController;
  //TODO: find a way to remove appProfileController form data source

  MeasurementRemoteDataSourceImpl(this.supabaseClient, this.appProfileController);

  @override
  Future<List<PresetMeasurementModel>> getAllMeasurements() async {
    try {
      final response = await supabaseClient.from(SupabaseTables.measurementsTable).select();
      return (response as List).map((e) => PresetMeasurementModel.fromJson(e)).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<PresetMeasurementModel>> getMyMeasurements() async {
    try {
      final profile = appProfileController.profile.data as p.PatientProfile;
      final myMeasurementIds = profile.myMeasurements.where((e) => e.isActive).map((e) => e.id).toSet();

      final allMeasurements = await getAllMeasurements();

      return allMeasurements.where((measurement) => myMeasurementIds.contains(measurement.id)).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<MeasurementEntryModel>> getMeasurementEntries({
    required String patientId,
    required String measurementId,
  }) async {
    try {
      final response = await supabaseClient
          .from(SupabaseTables.measurementEntriesTable)
          .select()
          .eq('patientId', patientId)
          .eq('measurementId', measurementId)
          .order('lastUpdated', ascending: false);

      return (response as List<dynamic>).map((entry) {
        final map = Map<String, dynamic>.from(entry as Map<dynamic, dynamic>);

        // Parse dates without using jsonEncode
        return MeasurementEntryModel(
          id: map['id'] ?? '',
          measurementId: map['measurementId'] ?? '',
          patientId: map['patientId'] ?? '',
          value: map['value']?.toString() ?? '0',
          note: map['note'] ?? '',
          lastUpdated: map['lastUpdated'] != null ? DateTime.parse(map['lastUpdated']) : DateTime.now(),
          createdAt: map['createdAt'] != null ? DateTime.parse(map['lastUpdated']) : DateTime.now(),
        );
      }).toList();
    } catch (e, stackTrace) {
      debugPrint('Error parsing measurement entries: $e\n$stackTrace');
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> addMeasurement({required MeasurementEntryModel measurementEntry}) async {
    try {
      await supabaseClient.from('measurementEntries').insert(measurementEntry.toMap());
    } catch (e) {
      debugPrint('Error adding measurement: $e');
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> toggleMyMeasurementStatus({required String measurementId}) async {
    try {
      final profile = appProfileController.profile.data as p.PatientProfile;

      final updatedMeasurements = [...profile.myMeasurements];
      final index = updatedMeasurements.indexWhere((m) => m.id == measurementId);

      if (index != -1) {
        final existing = updatedMeasurements[index];

        updatedMeasurements[index] = existing.copyWith(isActive: !existing.isActive);
      } else {
        // Adding a new measurement with sensible defaults
        updatedMeasurements.add(
          MyMeasurements(
            id: measurementId,
            visiblity: Visibility(type: VisibilityType.private, customAccess: []),
            isActive: true,
            time: const material.TimeOfDay(hour: 12, minute: 0),
            repetitionType: RepetitionType.none,
            weekdays: [],
            customDates: [],
          ),
        );
      }

      // Update Supabase
      await supabaseClient
          .from(SupabaseTables.patientsTable)
          .update({PatientsTableColumns.myMeasurements.name: updatedMeasurements.map((m) => m.toJson()).toList()})
          .eq('uid', profile.uid);

      // Re-fetch updated profile
      final response = await supabaseClient.from('fullPatientProfilesView').select().eq('uid', profile.uid).single();

      final updatedProfile = PatientProfileModel.fromJson(response);
      appProfileController.updateProfile(updatedProfile);
    } catch (e) {
      throw ServerException('Failed to update measurement status: $e');
    }
  }

  @override
  Future<Visibility> getMeasurementVisibility({required String measurementId}) async {
    try {
      final profile = appProfileController.profile.data as p.PatientProfile;

      final MyMeasurements myMeasurement = profile.myMeasurements.firstWhere((e) => e.id == measurementId);

      return myMeasurement.visiblity;
    } catch (e) {
      debugPrint("Error in measurement datasource: ${e.toString()}");
      throw (e.toString());
    }
  }

  @override
  Future<void> updateMeasurementVisibility({required String measurementId, required Visibility visibility}) async {
    try {
      final profile = appProfileController.profile.data as p.PatientProfile;

      final updatedMeasurements = [...profile.myMeasurements];
      final index = updatedMeasurements.indexWhere((m) => m.id == measurementId);

      if (index != -1) {
        updatedMeasurements[index].visiblity = visibility;
      } else {
        throw ("Measurement doesnot exsisit in profile!");
      }

      await supabaseClient
          .from(SupabaseTables.patientsTable)
          .update({PatientsTableColumns.myMeasurements.name: updatedMeasurements.map((m) => m.toJson()).toList()})
          .eq('uid', profile.uid);

      // Re-fetch updated profile
      final response = await supabaseClient.from('fullPatientProfilesView').select().eq('uid', profile.uid).single();

      final updatedProfile = PatientProfileModel.fromJson(response);
      appProfileController.updateProfile(updatedProfile);
    } catch (e) {
      debugPrint("Error in Measurement datasource: ${e.toString()}");
      throw (e.toString());
    }
  }

  @override
  Future<void> updateMyMeasurementReminderSettings({required MyMeasurements myMeasurement}) async {
    try {
      final profile = appProfileController.profile.data as p.PatientProfile;

      // Create updated measurements list
      final updatedMeasurements = [...profile.myMeasurements];
      final index = updatedMeasurements.indexWhere((m) => m.id == myMeasurement.id);

      if (index != -1) {
        // Update the measurement with new reminder settings
        updatedMeasurements[index] = myMeasurement.copyWith(
          time: myMeasurement.time,
          repetitionType: myMeasurement.repetitionType,
          weekdays: myMeasurement.weekdays,
          customDates: myMeasurement.customDates,
        );
      } else {
        throw "Measurement does not exist in profile!";
      }

      // Update in Supabase
      await supabaseClient
          .from(SupabaseTables.patientsTable)
          .update({PatientsTableColumns.myMeasurements.name: updatedMeasurements.map((m) => m.toJson()).toList()})
          .eq('uid', profile.uid);

      // Re-fetch updated profile
      final response = await supabaseClient.from('fullPatientProfilesView').select().eq('uid', profile.uid).single();

      final updatedProfile = PatientProfileModel.fromJson(response);
      appProfileController.updateProfile(updatedProfile);
    } catch (e) {
      debugPrint("Error in Measurement datasource: ${e.toString()}");
      throw ServerException(e.toString());
    }
  }
}
