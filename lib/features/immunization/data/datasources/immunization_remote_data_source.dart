import 'package:healthyways/core/constants/supabase/supabase_tables.dart';
import 'package:healthyways/features/immunization/data/models/immunization_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class ImmunizationRemoteDataSource {
  Future<List<ImmunizationModel>> getAllImmunizations();
  Future<void> createImmunizationEntry(ImmunizationModel immunization);
  Future<void> deleteImmunizationEntry(String id);
  Future<ImmunizationModel> updateImmunizationEntry({required String id, required String title, required String body});
}

class ImmunizationRemoteDataSourceImpl implements ImmunizationRemoteDataSource {
  SupabaseClient client;
  ImmunizationRemoteDataSourceImpl(this.client);

  @override
  Future<void> createImmunizationEntry(ImmunizationModel immunization) async {
    try {
      await client.from(SupabaseTables.immunizationTable).insert(immunization.toJson());
    } catch (e) {
      throw (e.toString());
    }
  }

  @override
  Future<void> deleteImmunizationEntry(String id) async {
    try {
      await client.from(SupabaseTables.immunizationTable).delete().eq("id", id);
    } catch (e) {
      throw (e.toString());
    }
  }

  @override
  Future<List<ImmunizationModel>> getAllImmunizations() async {
    try {
      final response = await client
          .from(SupabaseTables.immunizationTable)
          .select()
          .order('lastUpdated', ascending: false);

      final List<ImmunizationModel> immunizations = response.map((e) => ImmunizationModel.fromJson(e)).toList();

      return immunizations;
    } catch (e) {
      throw (e.toString());
    }
  }

  @override
  Future<ImmunizationModel> updateImmunizationEntry({
    required String id,
    required String title,
    required String body,
  }) async {
    try {
      await client
          .from(SupabaseTables.immunizationTable)
          .update({"title": title, "body": body, "lastUpdated": DateTime.now()})
          .eq("id", id);

      final response = await client.from(SupabaseTables.immunizationTable).select().eq("id", id).single();

      return ImmunizationModel.fromJson(response);
    } catch (e) {
      throw (e.toString());
    }
  }
}
