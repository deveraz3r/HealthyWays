import 'package:fpdart/fpdart.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/core/usecase/usecase.dart';
import 'package:healthyways/features/chat/domain/repositories/chat_repository.dart';

class DeleteMessage implements UseCase<void, DeleteMessageParams> {
  final ChatRepository repository;

  DeleteMessage(this.repository);

  @override
  Future<Either<Failure, void>> call(params) {
    return repository.deleteMessage(params.messageId);
  }
}

class DeleteMessageParams {
  final String messageId;

  DeleteMessageParams({required this.messageId});
}
