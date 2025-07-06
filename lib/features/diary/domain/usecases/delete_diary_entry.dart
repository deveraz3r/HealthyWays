import 'package:fpdart/fpdart.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/core/usecase/usecase.dart';
import 'package:healthyways/features/diary/domain/repositories/diary_repository.dart';

class DeleteDiaryEntry implements UseCase<void, DeleteDiaryEntryParams> {
  DiaryRepository repository;
  DeleteDiaryEntry(this.repository);

  @override
  Future<Either<Failure, void>> call(params) async {
    return await repository.deleteDiaryEntry(params.id);
  }
}

class DeleteDiaryEntryParams {
  String id;

  DeleteDiaryEntryParams({required this.id});
}
