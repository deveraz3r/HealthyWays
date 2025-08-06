import 'package:healthyways/features/chat/data/models/chat_room_model.dart';
import 'package:healthyways/features/chat/data/models/message_model.dart';

abstract class ChatRemoteDataSource {
  Future<void> createChatRoom(ChatRoomModel room);
  Future<ChatRoomModel?> getChatRoomByParticipants(List<String> participantIds);
  Future<List<ChatRoomModel>> getChatRoomsForUser(String userId);
  Future<void> sendMessage(MessageModel message);
  Future<List<MessageModel>> getMessagesForRoom(
    String roomId, {
    int limit,
    String? fromMessageId,
  });
  Future<void> markMessageAsRead(String messageId, String userId);
  Future<void> deleteMessage(String messageId);
}
