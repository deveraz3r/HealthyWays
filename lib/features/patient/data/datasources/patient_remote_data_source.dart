import 'package:flutter/material.dart' as material;
import 'package:healthyways/core/common/controllers/app_profile_controller.dart';
import 'package:healthyways/core/common/custom_types/shape.dart';
import 'package:healthyways/core/common/custom_types/visibility.dart';
import 'package:healthyways/core/constants/supabase/patients_table_columns.dart';
import 'package:healthyways/core/constants/supabase/supabase_tables.dart';
import 'package:healthyways/core/error/exceptions.dart';
import 'package:healthyways/core/common/models/patient_profile_model.dart';
import 'package:healthyways/features/measurements/data/models/measurement_entry_model.dart';
import 'package:healthyways/features/medication/data/models/medication_model.dart';
import 'package:healthyways/features/medication/data/models/medicine_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class PatientRemoteDataSource {
  Future<PatientProfileModel?> getPatientProfileById(String uid);
  Future<void> updatePatientProfile(PatientProfileModel profile);
  Future<List<PatientProfileModel>> getAllPatients();
  Future<void> updateVisibilitySettings({required String featureId, required Visibility visibility});
  Future<List<MedicationModel>> getAllMedications();
  Future<void> addMeasurementEntry({required MeasurementEntryModel measurementEntry});
  Future<MedicineModel> getMedicineById({required String id});
  Future<void> toggleMedicationStatusById({required String id, DateTime? timeTaken});
  Future<List<MeasurementEntryModel>> getMeasurementEntries({required String patientId, required String measurementId});

  Future<List<String>> getMyProviders();
  Future<void> addMyProvider(String providerId);
  Future<void> removeMyProvider(String providerId);
}

class PatientRemoteDataSourceImpl implements PatientRemoteDataSource {
  final AppProfileController appProfileController;
  final SupabaseClient supabaseClient;

  PatientRemoteDataSourceImpl({required this.appProfileController, required this.supabaseClient});

  @override
  Future<PatientProfileModel?> getPatientProfileById(String uid) async {
    try {
      final response =
          await supabaseClient.from(SupabaseTables.fullPatientProfilesView).select().eq("uid", uid).single();

      if (response.isEmpty) {
        return null;
      }

      return PatientProfileModel.fromJson(response);
    } catch (e) {
      print("Error in GetPatientByProfile: ${e.toString()}");
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> updatePatientProfile(PatientProfileModel profile) async {
    try {
      final response = await supabaseClient
          .from(SupabaseTables.patientsTable)
          .update(profile.toJson())
          .eq("uid", profile.uid);

      if (response == null) {
        throw ServerException("Failed to update patient profile");
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<PatientProfileModel>> getAllPatients() async {
    try {
      final response = await supabaseClient.from(SupabaseTables.patientsTable).select();

      return (response as List).map((data) => PatientProfileModel.fromJson(data)).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> updateVisibilitySettings({required String featureId, required Visibility visibility}) async {
    try {
      print("calling Update Visiblity settings with featureId $featureId");
      final profile = appProfileController.profile.data as PatientProfileModel;

      Map<String, dynamic> updateMap = {};
      PatientProfileModel updatedProfile;

      switch (featureId) {
        case 'allergies':
          updatedProfile = profile.copyWith(allergiesVisibility: visibility);
          updateMap[PatientsTableColumns.allergiesVisibility.name] = visibility.toJson();
          break;
        case 'immunizations':
          updatedProfile = profile.copyWith(immunizationsVisibility: visibility);
          updateMap[PatientsTableColumns.immunizationVisibility.name] = visibility.toJson();
          break;
        case 'labReports':
          updatedProfile = profile.copyWith(labReportsVisibility: visibility);
          updateMap[PatientsTableColumns.labReportsVisibility.name] = visibility.toJson();
          break;
        case 'diaries':
          updatedProfile = profile.copyWith(diariesVisibility: visibility);
          updateMap[PatientsTableColumns.diaryVisibility.name] = visibility.toJson();
          break;
        case 'measurements':
          updatedProfile = profile.copyWith(measurementsVisibility: visibility);
          updateMap[PatientsTableColumns.measurementsVisibility.name] = visibility.toJson();
          break;
        case 'global':
          updatedProfile = profile.copyWith(globalVisibility: visibility);
          print("Before: ${updatedProfile.globalVisibility.type}");
          print(PatientsTableColumns.globalVisibility.name);
          updateMap[PatientsTableColumns.globalVisibility.name] = visibility.toJson();
          break;
        default:
          throw ServerException('Invalid feature ID');
      }

      // Update Supabase
      await supabaseClient.from(SupabaseTables.patientsTable).update(updateMap).eq("uid", profile.uid);

      // Update local controller
      appProfileController.updateProfile(updatedProfile);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<MedicationModel>> getAllMedications() async {
    try {
      final response = await supabaseClient
          .from(SupabaseTables.medicationsTable)
          .select()
          .order('allocatedTime', ascending: true);

      return (response as List).map((med) => MedicationModel.fromJson(med)).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> addMeasurementEntry({required MeasurementEntryModel measurementEntry}) async {
    try {
      await supabaseClient.from('measurementEntries').insert(measurementEntry.toMap());
    } catch (e) {
      material.debugPrint('Error adding measurement: $e');
      throw ServerException(e.toString());
    }
  }

  @override
  Future<MedicineModel> getMedicineById({required String id}) async {
    try {
      final response = await supabaseClient.from(SupabaseTables.medicinesTable).select().eq('id', id).single();

      return MedicineModel.fromJson(response);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> toggleMedicationStatusById({required String id, DateTime? timeTaken}) async {
    try {
      // First get the current status
      final currentStatus =
          await supabaseClient.from(SupabaseTables.medicationsTable).select('isTaken').eq('id', id).single();

      final bool isCurrentlyTaken = currentStatus['isTaken'] as bool;

      // Update with toggled status
      await supabaseClient
          .from(SupabaseTables.medicationsTable)
          .update({
            'isTaken': !isCurrentlyTaken, // Toggle the status
            'takenTime': !isCurrentlyTaken ? timeTaken?.toIso8601String() : null, // Clear time if unmarking
          })
          .eq('id', id);
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
        return MeasurementEntryModel(
          id: map['id'] ?? '',
          measurementId: map['measurementId'] ?? '',
          patientId: map['patientId'] ?? '',
          value: map['value']?.toString() ?? '0',
          note: map['note'] ?? '',
          lastUpdated: DateTime.parse(map['lastUpdated']),
          createdAt: DateTime.parse(map['createdAt']),
        );
      }).toList();
    } catch (e) {
      material.debugPrint('Error getting measurement entries: $e');
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<String>> getMyProviders() async {
    try {
      final profile = appProfileController.profile.data as PatientProfileModel;
      return profile.myProviders;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> addMyProvider(String providerId) async {
    try {
      final profile = appProfileController.profile.data as PatientProfileModel;
      final updatedProviders = [...profile.myProviders, providerId];

      await supabaseClient
          .from(SupabaseTables.patientsTable)
          .update({'myProviders': updatedProviders})
          .eq('uid', profile.uid);

      // Update local profile
      final updatedProfile = profile.copyWith(myProviders: updatedProviders);
      appProfileController.updateProfile(updatedProfile);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> removeMyProvider(String providerId) async {
    try {
      final profile = appProfileController.profile.data as PatientProfileModel;
      final updatedProviders = profile.myProviders.where((id) => id != providerId).toList();

      await supabaseClient
          .from(SupabaseTables.patientsTable)
          .update({'myProviders': updatedProviders})
          .eq('uid', profile.uid);

      // Update local profile
      final updatedProfile = profile.copyWith(myProviders: updatedProviders);
      appProfileController.updateProfile(updatedProfile);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
