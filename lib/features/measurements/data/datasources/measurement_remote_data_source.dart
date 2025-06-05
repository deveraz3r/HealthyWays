import 'dart:convert';

import 'package:flutter/foundation.dart';
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
}

class MeasurementRemoteDataSourceImpl implements MeasurementRemoteDataSource {
  final SupabaseClient supabaseClient;
  final AppProfileController appProfileController;

  MeasurementRemoteDataSourceImpl(this.supabaseClient, this.appProfileController);

  @override
  Future<List<PresetMeasurementModel>> getAllMeasurements() async {
    try {
      final response = await supabaseClient.from('measurements').select();
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
          .from('measurementEntries')
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
      await supabaseClient.from('measurementEntries').insert(measurementEntry.toJson());
    } catch (e) {
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
        updatedMeasurements[index] = MyMeasurements(
          id: existing.id,
          visiblity: existing.visiblity,
          isActive: !existing.isActive,
        );
      } else {
        updatedMeasurements.add(
          MyMeasurements(
            id: measurementId,
            visiblity: Visibility(type: VisibilityType.private, customAccess: []),
            isActive: true,
          ),
        );
      }

      await supabaseClient
          .from('patients')
          .update({'myMeasurements': updatedMeasurements.map((m) => m.toJson()).toList()})
          .eq('uid', profile.uid);

      // Re-fetch updated profile
      final response = await supabaseClient.from('fullPatientProfilesView').select().eq('uid', profile.uid).single();

      final updatedProfile = PatientProfileModel.fromJson(response);
      appProfileController.updateProfile(updatedProfile);
    } catch (e) {
      throw ServerException('Failed to update measurement status: $e');
    }
  }
}
