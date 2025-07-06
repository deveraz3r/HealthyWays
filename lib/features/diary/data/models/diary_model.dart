import 'package:healthyways/features/diary/domain/entites/diary.dart';

class DiaryModel extends Diary {
  DiaryModel({
    required super.id,
    required super.patientId,
    super.providerId,
    required super.title,
    required super.body,
    required super.lastUpdated,
    required super.createdAt,
  });

  factory DiaryModel.fromJson(Map<String, dynamic> json) {
    return DiaryModel(
      id: json['id'] as String,
      patientId: json['patientId'] as String,
      providerId: json['providerId'] as String?,
      title: json['title'] as String,
      body: json['body'] as String,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'providerId': providerId,
      'title': title,
      'body': body,
      'lastUpdated': lastUpdated.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory DiaryModel.fromEntity(Diary diary) {
    return DiaryModel(
      id: diary.id,
      patientId: diary.patientId,
      providerId: diary.providerId,
      title: diary.title,
      body: diary.body,
      lastUpdated: diary.lastUpdated,
      createdAt: diary.createdAt,
    );
  }

  DiaryModel copyWith({
    String? id,
    String? patientId,
    String? providerId,
    String? title,
    String? body,
    DateTime? lastUpdated,
    DateTime? createdAt,
  }) {
    return DiaryModel(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      providerId: providerId ?? this.providerId,
      title: title ?? this.title,
      body: body ?? this.body,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
