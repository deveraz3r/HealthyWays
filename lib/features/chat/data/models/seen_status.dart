import 'package:healthyways/features/chat/domain/entities/seen_status.dart';

class SeenStatusModel extends SeenStatus {
  SeenStatusModel({
    required super.messageId,
    required super.userId,
    required super.seenAt,
  });

  factory SeenStatusModel.fromJson(Map<String, dynamic> json) {
    return SeenStatusModel(
      messageId: json['messageId'],
      userId: json['userId'],
      seenAt: DateTime.parse(json['seenAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'messageId': messageId,
      'userId': userId,
      'seenAt': seenAt.toIso8601String(),
    };
  }

  factory SeenStatusModel.fromEntity(SeenStatus status) {
    return SeenStatusModel(
      messageId: status.messageId,
      userId: status.userId,
      seenAt: status.seenAt,
    );
  }

  SeenStatus toEntity() => this;

  SeenStatusModel copyWith({
    String? messageId,
    String? userId,
    DateTime? seenAt,
  }) {
    return SeenStatusModel(
      messageId: messageId ?? this.messageId,
      userId: userId ?? this.userId,
      seenAt: seenAt ?? this.seenAt,
    );
  }
}
