import 'package:healthyways/core/constants/supabase/supabase_tables.dart';
import 'package:healthyways/core/error/exceptions.dart';
import 'package:healthyways/features/auth/data/models/pharmacist_profile_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class PharmacistRemoteDataSource {
  Future<PharmacistProfileModel?> getPharmacistProfileById(String uid);
  Future<void> updatePharmacistProfile(PharmacistProfileModel pharmacist);
  Future<List<PharmacistProfileModel>> getAllPharmacists();
}

class PharmacistRemoteDataSourceImpl implements PharmacistRemoteDataSource {
  final SupabaseClient supabaseClient;
  PharmacistRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<PharmacistProfileModel?> getPharmacistProfileById(String uid) async {
    try {
      final response =
          await supabaseClient.from(SupabaseTables.fullPharmacistProfilesView).select().eq("uid", uid).single();

      if (response.isEmpty) return null;

      return PharmacistProfileModel.fromJson(response);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> updatePharmacistProfile(PharmacistProfileModel pharmacist) async {
    try {
      await supabaseClient.from("pharmacists").update(pharmacist.toJson()).eq("uid", pharmacist.uid);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<PharmacistProfileModel>> getAllPharmacists() async {
    try {
      final response = await supabaseClient.from(SupabaseTables.fullPharmacistProfilesView).select();
      return (response as List).map((e) => PharmacistProfileModel.fromJson(e)).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
