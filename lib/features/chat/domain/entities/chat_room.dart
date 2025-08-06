class ChatRoom {
  final String id;
  final List<String> participantIds;
  final String? lastMessage;
  final DateTime? lastMessageTime;
  final bool isGroup;
  final String? groupName;
  final String? groupImageUrl;

  ChatRoom({
    required this.id,
    required this.participantIds,
    this.lastMessage,
    this.lastMessageTime,
    this.isGroup = false,
    this.groupName,
    this.groupImageUrl,
  });
}
