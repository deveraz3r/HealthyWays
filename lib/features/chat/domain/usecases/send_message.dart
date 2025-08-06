import 'package:fpdart/fpdart.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/core/usecase/usecase.dart';
import 'package:healthyways/features/chat/domain/entities/message.dart';
import 'package:healthyways/features/chat/domain/repositories/chat_repository.dart';

class SendMessage implements UseCase<void, SendMessageParams> {
  final ChatRepository repository;

  SendMessage(this.repository);

  @override
  Future<Either<Failure, void>> call(SendMessageParams params) {
    return repository.sendMessage(params.message);
  }
}

class SendMessageParams {
  final Message message;

  SendMessageParams({required this.message});
}
