import 'package:fpdart/fpdart.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/core/usecase/usecase.dart';
import 'package:healthyways/features/diary/domain/entites/diary.dart';
import 'package:healthyways/features/diary/domain/repositories/diary_repository.dart';

class GetAllDiaryEntriesParams {
  final String patientId;
  GetAllDiaryEntriesParams({required this.patientId});
}

class GetAllDiaryEntries
    implements UseCase<List<Diary>, GetAllDiaryEntriesParams> {
  DiaryRepository repository;
  GetAllDiaryEntries(this.repository);

  @override
  Future<Either<Failure, List<Diary>>> call(
    GetAllDiaryEntriesParams params,
  ) async {
    return await repository.getAllDiaryEntries(params.patientId);
  }
}
