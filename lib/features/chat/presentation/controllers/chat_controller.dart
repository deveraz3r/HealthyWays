import 'package:get/get.dart';
import 'package:healthyways/features/chat/domain/usecases/create_chat_room.dart';
import 'package:uuid/uuid.dart';
import 'package:healthyways/core/common/controllers/app_profile_controller.dart';
import 'package:healthyways/core/controller/controller_state_manager.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/features/chat/domain/entities/chat_room.dart';
import 'package:healthyways/features/chat/domain/entities/message.dart';
import 'package:healthyways/features/chat/domain/usecases/delete_message.dart';
import 'package:healthyways/features/chat/domain/usecases/get_chat_rooms_for_user.dart';
import 'package:healthyways/features/chat/domain/usecases/get_messages_for_room.dart';
import 'package:healthyways/features/chat/domain/usecases/mark_message_as_read.dart';
import 'package:healthyways/features/chat/domain/usecases/send_message.dart';
import 'package:healthyways/features/chat/presentation/pages/chat_messages_page.dart';

class ChatController extends GetxController {
  final AppProfileController _profileController;
  final GetOrCreateChatRoom _getOrCreateChatRoom;
  final GetChatRoomsForUser _getChatRoomsForUser;
  final SendMessage _sendMessage;
  final GetMessagesForRoom _getMessagesForRoom;
  final MarkMessageAsRead _markMessageAsRead;
  final DeleteMessage _deleteMessage;

  ChatController({
    required AppProfileController profileController,
    required GetOrCreateChatRoom getOrCreateChatRoom,
    required GetChatRoomsForUser getChatRoomsForUser,
    required SendMessage sendMessage,
    required GetMessagesForRoom getMessagesForRoom,
    required MarkMessageAsRead markMessageAsRead,
    required DeleteMessage deleteMessage,
  }) : _profileController = profileController,
       _getOrCreateChatRoom = getOrCreateChatRoom,
       _getChatRoomsForUser = getChatRoomsForUser,
       _sendMessage = sendMessage,
       _getMessagesForRoom = getMessagesForRoom,
       _markMessageAsRead = markMessageAsRead,
       _deleteMessage = deleteMessage;

  final chatRooms = StateController<Failure, List<ChatRoom>>();
  final messages = StateController<Failure, List<Message>>();
  final isSendingMessage = false.obs;

  /// Fetch all chat rooms where current user is a participant
  Future<void> fetchChatRooms() async {
    final userId = _profileController.profile.data?.uid;
    if (userId == null) return;

    chatRooms.setLoading();

    final result = await _getChatRoomsForUser(
      GetChatRoomsForUserParams(userId: userId),
    );
    result.fold(
      (failure) => chatRooms.setError(failure),
      (data) => chatRooms.setData(data),
    );
  }

  /// Send a message in a given room
  Future<void> sendChatMessage({
    required String chatRoomId,
    required String content,
  }) async {
    final profile = _profileController.profile.data!;
    final message = Message(
      id: const Uuid().v4(),
      chatRoomId: chatRoomId,
      senderId: profile.uid,
      content: content,
      type: MessageType.text,
      timestamp: DateTime.now(),
    );

    isSendingMessage.value = true;

    final result = await _sendMessage(SendMessageParams(message: message));

    result.fold((failure) => Get.snackbar('Error', failure.message), (_) {
      fetchMessages(chatRoomId);
    });

    isSendingMessage.value = false;
  }

  /// Get or create a chat room and navigate to the chat page
  Future<void> openChatWith(List<String> participantIds) async {
    final result = await _getOrCreateChatRoom(
      GetOrCreateChatRoomParams(participantIds: participantIds),
    );

    result.fold(
      (failure) => Get.snackbar('Error', failure.message),
      (room) => Get.to(() => ChatMessagesPage(room: room)),
    );
  }

  /// Fetch messages for a room (optionally paginated)
  Future<void> fetchMessages(String chatRoomId, {String? fromMessageId}) async {
    messages.setLoading();

    final result = await _getMessagesForRoom(
      GetMessagesForRoomParams(
        roomId: chatRoomId,
        fromMessageId: fromMessageId,
      ),
    );

    result.fold(
      (failure) => messages.setError(failure),
      (data) => messages.setData(data),
    );
  }

  /// Mark a message as read
  Future<void> markAsRead(String messageId) async {
    final userId = _profileController.profile.data?.uid;
    if (userId == null) return;

    await _markMessageAsRead(
      MarkMessageAsReadParams(messageId: messageId, userId: userId),
    );
  }

  /// Delete a message
  Future<void> deleteMessage(String messageId, String chatRoomId) async {
    final result = await _deleteMessage(
      DeleteMessageParams(messageId: messageId),
    );

    result.fold(
      (failure) => Get.snackbar('Error', failure.message),
      (_) => fetchMessages(chatRoomId),
    );
  }
}
