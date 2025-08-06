import 'package:fpdart/fpdart.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/core/usecase/usecase.dart';
import 'package:healthyways/features/chat/domain/entities/message.dart';
import 'package:healthyways/features/chat/domain/repositories/chat_repository.dart';

class GetMessagesForRoom
    implements UseCase<List<Message>, GetMessagesForRoomParams> {
  final ChatRepository repository;

  GetMessagesForRoom(this.repository);

  @override
  Future<Either<Failure, List<Message>>> call(GetMessagesForRoomParams params) {
    return repository.getMessagesForRoom(
      params.roomId,
      limit: params.limit,
      fromMessageId: params.fromMessageId,
    );
  }
}

class GetMessagesForRoomParams {
  final String roomId;
  final int limit;
  final String? fromMessageId;

  GetMessagesForRoomParams({
    required this.roomId,
    this.limit = 50,
    this.fromMessageId,
  });
}
