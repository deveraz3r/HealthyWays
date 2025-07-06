import 'package:healthyways/core/constants/supabase/supabase_tables.dart';
import 'package:healthyways/features/diary/data/models/diary_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class DiaryRemoteDataSource {
  Future<List<DiaryModel>> getAllDiaryEntries();
  Future<void> createDiaryEntry(DiaryModel diary);
  Future<void> deleteDiaryEntry(String id);
  Future<DiaryModel> updateDiaryEntry({required String id, required String title, required String body});
}

class DiaryRemoteDataSourceImpl implements DiaryRemoteDataSource {
  SupabaseClient client;
  DiaryRemoteDataSourceImpl(this.client);

  @override
  Future<void> createDiaryEntry(DiaryModel diary) async {
    try {
      await client.from(SupabaseTables.diaryTable).insert(diary.toJson());
    } catch (e) {
      throw (e.toString());
    }
  }

  @override
  Future<void> deleteDiaryEntry(String id) async {
    try {
      await client.from(SupabaseTables.diaryTable).delete().eq("id", id);
    } catch (e) {
      throw (e.toString());
    }
  }

  @override
  Future<List<DiaryModel>> getAllDiaryEntries() async {
    try {
      final response = await client
          .from(SupabaseTables.diaryTable)
          .select()
          .order('lastUpdated', ascending: false); // Sort by lastUpdated descending;

      final List<DiaryModel> diaryEntries = response.map((e) => DiaryModel.fromJson(e)).toList();

      return diaryEntries;
    } catch (e) {
      throw (e.toString());
    }
  }

  @override
  Future<DiaryModel> updateDiaryEntry({required String id, required String title, required String body}) async {
    try {
      await client
          .from(SupabaseTables.diaryTable)
          .update({"title": title, "body": body, "lastUpdated": DateTime.now()})
          .eq("id", id);

      final response = await client.from(SupabaseTables.diaryTable).select().eq("id", id).single();

      return DiaryModel.fromJson(response);
    } catch (e) {
      throw (e.toString());
    }
  }
}
