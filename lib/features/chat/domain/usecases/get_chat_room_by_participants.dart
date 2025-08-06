import 'package:fpdart/fpdart.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/core/usecase/usecase.dart';
import 'package:healthyways/features/chat/domain/entities/chat_room.dart';
import 'package:healthyways/features/chat/domain/repositories/chat_repository.dart';

class GetChatRoomByParticipants
    implements UseCase<ChatRoom?, GetChatRoomByParticipantsParams> {
  final ChatRepository repository;

  GetChatRoomByParticipants(this.repository);

  @override
  Future<Either<Failure, ChatRoom?>> call(
    GetChatRoomByParticipantsParams params,
  ) {
    return repository.getChatRoomByParticipants(params.participantIds);
  }
}

class GetChatRoomByParticipantsParams {
  final List<String> participantIds;

  GetChatRoomByParticipantsParams({required this.participantIds});
}
