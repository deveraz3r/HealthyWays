import 'package:healthyways/core/constants/supabase/supabase_tables.dart';
import 'package:healthyways/core/error/exceptions.dart';
import 'package:healthyways/core/common/models/doctor_profile_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class DoctorRemoteDataSource {
  Future<DoctorProfileModel?> getDoctorProfileById(String uid);
  Future<void> updateDoctorProfile(DoctorProfileModel doctor);
  Future<List<DoctorProfileModel>> getAllDoctors();
  Future<void> addMyPatient(String patientId);
}

class DoctorRemoteDataSourceImpl implements DoctorRemoteDataSource {
  @override
  Future<void> addMyPatient(String patientId) async {
    try {
      // Example: Insert into a doctor_patient_link table
      await supabaseClient.from('doctor_patient_link').insert({
        'doctorId': supabaseClient.auth.currentUser!.id,
        'patientId': patientId,
      });
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  final SupabaseClient supabaseClient;

  DoctorRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<DoctorProfileModel?> getDoctorProfileById(String uid) async {
    try {
      final response =
          await supabaseClient
              .from(SupabaseTables.doctorsTable)
              .select()
              .eq("uid", uid)
              .single();

      if (response.isEmpty) return null;

      return DoctorProfileModel.fromJson(response);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> updateDoctorProfile(DoctorProfileModel doctor) async {
    try {
      // Update doctor data in doctors table
      await supabaseClient
          .from(SupabaseTables.doctorsTable)
          .update(doctor.toJson())
          .eq("uid", doctor.uid);

      // Update profile data in profiles table
      await supabaseClient
          .from(SupabaseTables.baseProfileTable)
          .update(doctor.toJson())
          .eq("uid", doctor.uid);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<DoctorProfileModel>> getAllDoctors() async {
    try {
      final response =
          await supabaseClient
              .from(SupabaseTables.fullDoctorProfilesView)
              .select();
      return (response as List)
          .map((e) => DoctorProfileModel.fromJson(e))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
