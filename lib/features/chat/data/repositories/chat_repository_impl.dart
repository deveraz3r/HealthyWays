import 'package:fpdart/fpdart.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/features/chat/data/datasources/chat_remote_data_source.dart';
import 'package:healthyways/features/chat/data/models/chat_room_model.dart';
import 'package:healthyways/features/chat/data/models/message_model.dart';
import 'package:healthyways/features/chat/domain/entities/chat_room.dart';
import 'package:healthyways/features/chat/domain/entities/message.dart';
import 'package:healthyways/features/chat/domain/repositories/chat_repository.dart';
import 'package:uuid/uuid.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, ChatRoom>> getOrCreateChatRoom(
    List<String> participantIds,
  ) async {
    try {
      final existingRoom = await remoteDataSource.getChatRoomByParticipants(
        participantIds,
      );

      if (existingRoom != null) {
        return right(existingRoom.toEntity());
      }

      final newRoom = ChatRoomModel(
        id: const Uuid().v4(),
        participantIds: participantIds,
        isGroup: false,
        lastMessage: null,
        lastMessageTime: null,
        groupImageUrl: null,
        groupName: null,
      );

      await remoteDataSource.createChatRoom(newRoom);
      return right(newRoom.toEntity());
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ChatRoom?>> getChatRoomByParticipants(
    List<String> participantIds,
  ) async {
    try {
      final result = await remoteDataSource.getChatRoomByParticipants(
        participantIds,
      );
      return right(result?.toEntity());
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ChatRoom>>> getChatRoomsForUser(
    String userId,
  ) async {
    try {
      final list = await remoteDataSource.getChatRoomsForUser(userId);
      return right(list.map((e) => e.toEntity()).toList());
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> sendMessage(Message message) async {
    try {
      final model = MessageModel.fromEntity(message);
      await remoteDataSource.sendMessage(model);
      return right(null);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Message>>> getMessagesForRoom(
    String roomId, {
    int limit = 50,
    String? fromMessageId,
  }) async {
    try {
      final list = await remoteDataSource.getMessagesForRoom(
        roomId,
        limit: limit,
        fromMessageId: fromMessageId,
      );
      return right(list.map((e) => e.toEntity()).toList());
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markMessageAsRead(
    String messageId,
    String userId,
  ) async {
    try {
      await remoteDataSource.markMessageAsRead(messageId, userId);
      return right(null);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteMessage(String messageId) async {
    try {
      await remoteDataSource.deleteMessage(messageId);
      return right(null);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
