import 'package:healthyways/features/diary/data/models/diary_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class DiaryRemoteDataSource {
  Future<List<DiaryModel>> getAllDiaryEntries();
  Future<DiaryModel> createDiaryEntry(DiaryModel diary);
  Future<void> deleteDiaryEntry(String id);
  Future<DiaryModel> updateDiaryEntry(DiaryModel diary);
}

class DiaryRemoteDataSourceImpl implements DiaryRemoteDataSource {
  SupabaseClient client;
  DiaryRemoteDataSourceImpl(this.client);

  @override
  Future<DiaryModel> createDiaryEntry(DiaryModel diary) {
    // TODO: implement createDiaryEntry
    throw UnimplementedError();
  }

  @override
  Future<void> deleteDiaryEntry(String id) {
    // TODO: implement deleteDiaryEntry
    throw UnimplementedError();
  }

  @override
  Future<List<DiaryModel>> getAllDiaryEntries() {
    // TODO: implement getAllDiaryEntries
    throw UnimplementedError();
  }

  @override
  Future<DiaryModel> updateDiaryEntry(DiaryModel diary) {
    // TODO: implement updateDiaryEntry
    throw UnimplementedError();
  }
}
