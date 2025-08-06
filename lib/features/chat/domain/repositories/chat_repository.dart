import 'package:fpdart/fpdart.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/features/chat/domain/entities/chat_room.dart';
import 'package:healthyways/features/chat/domain/entities/message.dart';

abstract class ChatRepository {
  // Future<Either<Failure, void>> createChatRoom(ChatRoom room);
  Future<Either<Failure, ChatRoom>> getOrCreateChatRoom(
    List<String> participantIds,
  );
  Future<Either<Failure, ChatRoom?>> getChatRoomByParticipants(
    List<String> participantIds,
  );
  Future<Either<Failure, List<ChatRoom>>> getChatRoomsForUser(String userId);
  Future<Either<Failure, void>> sendMessage(Message message);
  Future<Either<Failure, List<Message>>> getMessagesForRoom(
    String roomId, {
    int limit,
    String? fromMessageId,
  });
  Future<Either<Failure, void>> markMessageAsRead(
    String messageId,
    String userId,
  );
  Future<Either<Failure, void>> deleteMessage(String messageId);
}
