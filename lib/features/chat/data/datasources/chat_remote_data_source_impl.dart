import 'package:healthyways/core/constants/supabase/supabase_tables.dart';
import 'package:healthyways/core/error/exceptions.dart';
import 'package:healthyways/features/chat/data/datasources/chat_remote_data_source.dart';
import 'package:healthyways/features/chat/data/models/chat_room_model.dart';
import 'package:healthyways/features/chat/data/models/message_model.dart';
import 'package:healthyways/features/chat/data/models/seen_status.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final SupabaseClient supabaseClient;

  ChatRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<void> createChatRoom(ChatRoomModel room) async {
    try {
      await supabaseClient
          .from(SupabaseTables.chatRoomsTable)
          .insert(room.toJson());
    } catch (e) {
      throw ServerException('Failed to create chat room: $e');
    }
  }

  @override
  Future<ChatRoomModel?> getChatRoomByParticipants(
    List<String> participantIds,
  ) async {
    try {
      final response =
          await supabaseClient
              .from(SupabaseTables.chatRoomsTable)
              .select()
              .contains('participantIds', participantIds)
              .maybeSingle();

      return response != null ? ChatRoomModel.fromJson(response) : null;
    } catch (e) {
      throw ServerException('Failed to get chat room: $e');
    }
  }

  @override
  Future<List<ChatRoomModel>> getChatRoomsForUser(String userId) async {
    try {
      final response = await supabaseClient
          .from(SupabaseTables.chatRoomsTable)
          .select()
          .contains('participantIds', [userId])
          .order('lastMessageTime', ascending: false);

      return (response as List).map((e) => ChatRoomModel.fromJson(e)).toList();
    } catch (e) {
      throw ServerException('Failed to fetch chat rooms: $e');
    }
  }

  @override
  Future<void> sendMessage(MessageModel message) async {
    try {
      await supabaseClient
          .from(SupabaseTables.messagesTable)
          .insert(message.toJson());

      // Optionally update lastMessage in chat room
      await supabaseClient
          .from(SupabaseTables.chatRoomsTable)
          .update({
            'lastMessage': message.content,
            'lastMessageTime': message.timestamp.toIso8601String(),
          })
          .eq('id', message.chatRoomId);
    } catch (e) {
      throw ServerException('Failed to send message: $e');
    }
  }

  @override
  Future<List<MessageModel>> getMessagesForRoom(
    String roomId, {
    int limit = 50,
    String? fromMessageId,
  }) async {
    try {
      final query = supabaseClient
          .from(SupabaseTables.messagesTable)
          .select()
          .eq('chatRoomId', roomId)
          .order('timestamp', ascending: false)
          .limit(limit);

      if (fromMessageId != null) {
        final fromMessage =
            await supabaseClient
                .from(SupabaseTables.messagesTable)
                .select()
                .eq('id', fromMessageId)
                .maybeSingle();

        if (fromMessage != null) {
          final fromTimestamp = DateTime.parse(fromMessage['timestamp']);

          // The fix: use another query with all filters applied before select()
          final response = await supabaseClient
              .from(SupabaseTables.messagesTable)
              .select()
              .eq('chatRoomId', roomId)
              .lt('timestamp', fromTimestamp.toIso8601String())
              .order('timestamp', ascending: false)
              .limit(limit);

          return (response as List)
              .map((e) => MessageModel.fromJson(e))
              .toList();
        }
      }

      // Default query if no fromMessageId is provided
      final response = await query;

      return (response as List).map((e) => MessageModel.fromJson(e)).toList();
    } catch (e) {
      throw ServerException('Failed to fetch messages: $e');
    }
  }

  @override
  Future<void> markMessageAsRead(String messageId, String userId) async {
    try {
      final seenStatus = SeenStatusModel(
        messageId: messageId,
        userId: userId,
        seenAt: DateTime.now(),
      );

      await supabaseClient
          .from(SupabaseTables.seenStatusTable)
          .upsert(seenStatus.toJson());
    } catch (e) {
      throw ServerException('Failed to mark message as read: $e');
    }
  }

  @override
  Future<void> deleteMessage(String messageId) async {
    try {
      await supabaseClient
          .from(SupabaseTables.messagesTable)
          .delete()
          .eq('id', messageId);
    } catch (e) {
      throw ServerException('Failed to delete message: $e');
    }
  }
}
