import 'package:healthyways/features/chat/domain/entities/chat_room.dart';

class ChatRoomModel extends ChatRoom {
  ChatRoomModel({
    required super.id,
    required super.participantIds,
    super.lastMessage,
    super.lastMessageTime,
    super.isGroup,
    super.groupName,
    super.groupImageUrl,
  });

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) {
    return ChatRoomModel(
      id: json['id'],
      participantIds: List<String>.from(json['participantIds']),
      lastMessage: json['lastMessage'],
      lastMessageTime:
          json['lastMessageTime'] != null
              ? DateTime.parse(json['lastMessageTime'])
              : null,
      isGroup: json['isGroup'] ?? false,
      groupName: json['groupName'],
      groupImageUrl: json['groupImageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'participantIds': participantIds,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime?.toIso8601String(),
      'isGroup': isGroup,
      'groupName': groupName,
      'groupImageUrl': groupImageUrl,
    };
  }

  factory ChatRoomModel.fromEntity(ChatRoom chatRoom) {
    return ChatRoomModel(
      id: chatRoom.id,
      participantIds: chatRoom.participantIds,
      lastMessage: chatRoom.lastMessage,
      lastMessageTime: chatRoom.lastMessageTime,
      isGroup: chatRoom.isGroup,
      groupName: chatRoom.groupName,
      groupImageUrl: chatRoom.groupImageUrl,
    );
  }

  ChatRoom toEntity() => this;

  ChatRoomModel copyWith({
    String? id,
    List<String>? participantIds,
    String? lastMessage,
    DateTime? lastMessageTime,
    bool? isGroup,
    String? groupName,
    String? groupImageUrl,
  }) {
    return ChatRoomModel(
      id: id ?? this.id,
      participantIds: participantIds ?? this.participantIds,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      isGroup: isGroup ?? this.isGroup,
      groupName: groupName ?? this.groupName,
      groupImageUrl: groupImageUrl ?? this.groupImageUrl,
    );
  }
}
