import 'package:fpdart/fpdart.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/core/usecase/usecase.dart';
import 'package:healthyways/features/diary/domain/entites/diary.dart';
import 'package:healthyways/features/diary/domain/repositories/diary_repository.dart';

class CreateDiaryEntry implements UseCase<Diary, CreateDiaryEntryParams> {
  DiaryRepository repository;
  CreateDiaryEntry(this.repository);

  @override
  Future<Either<Failure, Diary>> call(params) async {
    return await repository.createDiaryEntry(params.diary);
  }
}

class CreateDiaryEntryParams {
  Diary diary;

  CreateDiaryEntryParams({required this.diary});
}
