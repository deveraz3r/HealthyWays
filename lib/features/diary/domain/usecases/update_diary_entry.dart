import 'package:fpdart/fpdart.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/core/usecase/usecase.dart';
import 'package:healthyways/features/diary/domain/entites/diary.dart';
import 'package:healthyways/features/diary/domain/repositories/diary_repository.dart';

class UpdateDiaryEntry implements UseCase<Diary, UpdateDiaryEntryParams> {
  DiaryRepository repository;
  UpdateDiaryEntry(this.repository);

  @override
  Future<Either<Failure, Diary>> call(params) async {
    return await repository.updateDiaryEntry(id: params.id, title: params.title, body: params.body);
  }
}

class UpdateDiaryEntryParams {
  String id;
  String title;
  String body;

  UpdateDiaryEntryParams({required this.id, required this.title, required this.body});
}
