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
  Future<Either<Failure, void>> createDiaryEntry(Diary diary) async {
    try {
      await dataSource.createDiaryEntry(DiaryModel.fromEntity(diary));

      return right(null);
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
  Future<Either<Failure, List<Diary>>> getAllDiaryEntries(
    String patientId,
  ) async {
    try {
      final response = await dataSource.getAllDiaryEntries(patientId);

      return right(response);
    } on ServerException catch (e) {
      throw Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, Diary>> updateDiaryEntry({
    required String id,
    required String title,
    required String body,
  }) async {
    try {
      final response = await dataSource.updateDiaryEntry(
        id: id,
        title: title,
        body: body,
      );

      return right(response);
    } on ServerException catch (e) {
      throw Left(Failure(e.message));
    }
  }
}
