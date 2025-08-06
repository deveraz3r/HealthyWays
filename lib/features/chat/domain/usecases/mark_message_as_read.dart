import 'package:fpdart/fpdart.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/core/usecase/usecase.dart';
import 'package:healthyways/features/chat/domain/repositories/chat_repository.dart';

class MarkMessageAsRead implements UseCase<void, MarkMessageAsReadParams> {
  final ChatRepository repository;

  MarkMessageAsRead(this.repository);

  @override
  Future<Either<Failure, void>> call(MarkMessageAsReadParams params) {
    return repository.markMessageAsRead(params.messageId, params.userId);
  }
}

class MarkMessageAsReadParams {
  final String messageId;
  final String userId;

  MarkMessageAsReadParams({required this.messageId, required this.userId});
}
