import 'package:fpdart/fpdart.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/core/usecase/usecase.dart';
import 'package:healthyways/features/chat/domain/entities/chat_room.dart';
import 'package:healthyways/features/chat/domain/repositories/chat_repository.dart';

class GetOrCreateChatRoom
    implements UseCase<ChatRoom, GetOrCreateChatRoomParams> {
  final ChatRepository repository;

  GetOrCreateChatRoom(this.repository);

  @override
  Future<Either<Failure, ChatRoom>> call(GetOrCreateChatRoomParams params) {
    return repository.getOrCreateChatRoom(params.participantIds);
  }
}

class GetOrCreateChatRoomParams {
  final List<String> participantIds;

  GetOrCreateChatRoomParams({required this.participantIds});
}
