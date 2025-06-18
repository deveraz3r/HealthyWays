import 'package:fpdart/src/either.dart';
import 'package:healthyways/core/error/exceptions.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/features/diary/data/datasources/diary_remote_data_source.dart';
import 'package:healthyways/features/diary/data/models/diary_model.dart';
import 'package:healthyways/features/diary/domain/entites/diary.dart';
import 'package:healthyways/features/diary/domain/repositories/diary_repository.dart';

class DiaryRepositoryImpl implements DiaryRepository {
  DiaryRemoteDataSource dataSource;
  DiaryRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, Diary>> createDiaryEntry(Diary diary) async {
    try {
      final DiaryModel diaryModel = DiaryModel(id: diary.id);

      final response = await dataSource.createDiaryEntry(diaryModel);

      return right(response);
    } on ServerException catch (e) {
      throw Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteDiaryEntry(String id) async {
    try {
      await dataSource.deleteDiaryEntry(id);

      return right(null);
    } on ServerException catch (e) {
      throw Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Diary>>> getAllDiaryEntries() async {
    try {
      final response = await dataSource.getAllDiaryEntries();

      return right(response);
    } on ServerException catch (e) {
      throw Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, Diary>> updateDiaryEntry(Diary diary) async {
    try {
      final DiaryModel diaryModel = DiaryModel(id: diary.id);

      final response = await dataSource.updateDiaryEntry(diaryModel);

      return right(response);
    } on ServerException catch (e) {
      throw Left(Failure(e.message));
    }
  }
}
