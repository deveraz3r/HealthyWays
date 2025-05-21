import 'package:healthyways/core/error/exceptions.dart';
import 'package:healthyways/features/doctor/data/models/doctor_profile_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class DoctorRemoteDataSource {
  Future<DoctorProfileModel?> getDoctorProfileById(String uid);
  Future<void> updateDoctorProfile(DoctorProfileModel doctor);
  Future<List<DoctorProfileModel>> getAllDoctors();
}

class DoctorRemoteDataSourceImpl implements DoctorRemoteDataSource {
  final SupabaseClient supabaseClient;

  DoctorRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<DoctorProfileModel?> getDoctorProfileById(String uid) async {
    try {
      final response =
          await supabaseClient.from("doctors").select().eq("uid", uid).single();

      if (response.isEmpty) return null;

      return DoctorProfileModel.fromJson(response);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> updateDoctorProfile(DoctorProfileModel doctor) async {
    try {
      await supabaseClient
          .from("doctors")
          .update(doctor.toJson())
          .eq("uid", doctor.uid);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<DoctorProfileModel>> getAllDoctors() async {
    try {
      final response = await supabaseClient.from("doctors").select();
      return (response as List)
          .map((e) => DoctorProfileModel.fromJson(e))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
