import 'package:fpdart/fpdart.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/core/usecase/usecase.dart';
import 'package:healthyways/features/diary/domain/entites/diary.dart';
import 'package:healthyways/features/diary/domain/repositories/diary_repository.dart';

class GetAllDiaryEntries implements UseCase<List<Diary>, NoParams> {
  DiaryRepository repository;
  GetAllDiaryEntries(this.repository);

  @override
  Future<Either<Failure, List<Diary>>> call(params) async {
    return await repository.getAllDiaryEntries();
  }
}
