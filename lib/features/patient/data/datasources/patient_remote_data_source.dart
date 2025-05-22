import 'package:healthyways/core/error/exceptions.dart';
import 'package:healthyways/features/patient/data/models/patient_profile_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class PatientRemoteDataSource {
  Future<PatientProfileModel?> getPatientProfileById(String uid);
  Future<void> updatePatientProfile(PatientProfileModel profile);
  Future<List<PatientProfileModel>> getAllPatients();
}

class PatientRemoteDataSourceImpl implements PatientRemoteDataSource {
  final SupabaseClient supabaseClient;
  PatientRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<PatientProfileModel?> getPatientProfileById(String uid) async {
    try {
      final response =
          await supabaseClient
              .from("fullPatientProfilesView")
              .select()
              .eq("uid", uid)
              .single();

      if (response.isEmpty) {
        return null;
      }

      print("Response: $response");

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
          .from("patients")
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
      final response = await supabaseClient.from("patients").select();

      return (response as List)
          .map((data) => PatientProfileModel.fromJson(data))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
