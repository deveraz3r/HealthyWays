import 'package:fpdart/fpdart.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/features/diary/domain/entites/diary.dart';

abstract interface class DiaryRepository {
  Future<Either<Failure, List<Diary>>> getAllDiaryEntries();
  Future<Either<Failure, void>> createDiaryEntry(Diary diary);
  Future<Either<Failure, void>> deleteDiaryEntry(String id);
  Future<Either<Failure, Diary>> updateDiaryEntry({required String id, required String title, required String body});
}
