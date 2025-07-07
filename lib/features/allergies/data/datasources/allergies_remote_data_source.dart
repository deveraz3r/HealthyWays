import 'package:healthyways/core/constants/supabase/supabase_tables.dart';
import 'package:healthyways/features/allergies/data/models/allergie_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AllergiesRemoteDataSource {
  Future<List<AllergieModel>> getAllAllergieEntries();
  Future<void> createAllergieEntry(AllergieModel allergie);
  Future<void> deleteAllergieEntry(String id);
  Future<AllergieModel> updateAllergieEntry({required String id, required String title, required String body});
}

class AllergiesRemoteDataSourceImpl implements AllergiesRemoteDataSource {
  final SupabaseClient client;
  const AllergiesRemoteDataSourceImpl(this.client);

  @override
  Future<void> createAllergieEntry(AllergieModel allergie) async {
    try {
      await client.from(SupabaseTables.allergiesTable).insert(allergie.toJson());
    } catch (e) {
      throw (e.toString());
    }
  }

  @override
  Future<void> deleteAllergieEntry(String id) async {
    try {
      await client.from(SupabaseTables.allergiesTable).delete().eq("id", id);
    } catch (e) {
      throw (e.toString());
    }
  }

  @override
  Future<List<AllergieModel>> getAllAllergieEntries() async {
    try {
      final response = await client.from(SupabaseTables.allergiesTable).select().order('lastUpdated', ascending: false);

      final List<AllergieModel> allAllergies = response.map((e) => AllergieModel.fromJson(e)).toList();

      return allAllergies;
    } catch (e) {
      throw (e.toString());
    }
  }

  @override
  Future<AllergieModel> updateAllergieEntry({required String id, required String title, required String body}) async {
    try {
      await client
          .from(SupabaseTables.allergiesTable)
          .update({"title": title, "body": body, "lastUpdated": DateTime.now()})
          .eq("id", id);

      final response = await client.from(SupabaseTables.allergiesTable).select().eq("id", id).single();

      return AllergieModel.fromJson(response);
    } catch (e) {
      throw (e.toString());
    }
  }
}
