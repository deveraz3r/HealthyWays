import 'package:fpdart/fpdart.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/core/usecase/usecase.dart';
import 'package:healthyways/features/chat/domain/entities/chat_room.dart';
import 'package:healthyways/features/chat/domain/repositories/chat_repository.dart';

class GetChatRoomsForUser
    implements UseCase<List<ChatRoom>, GetChatRoomsForUserParams> {
  final ChatRepository repository;

  GetChatRoomsForUser(this.repository);

  @override
  Future<Either<Failure, List<ChatRoom>>> call(params) {
    return repository.getChatRoomsForUser(params.userId);
  }
}

class GetChatRoomsForUserParams {
  final String userId;

  GetChatRoomsForUserParams({required this.userId});
}
