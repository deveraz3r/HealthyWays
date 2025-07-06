import 'package:healthyways/features/immunization/domain/entities/immunization.dart';

class ImmunizationModel extends Immunization {
  const ImmunizationModel({
    required super.id,
    required super.patientId,
    super.providerId,
    required super.title,
    required super.body,
    required super.lastUpdated,
    required super.createdAt,
  });

  /// Convert JSON to ImmunizationModel
  factory ImmunizationModel.fromJson(Map<String, dynamic> json) {
    return ImmunizationModel(
      id: json['id'] ?? '',
      patientId: json['patientId'] ?? '',
      providerId: json['providerId'],
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      lastUpdated: json['lastUpdated'] != null ? DateTime.parse(json['lastUpdated']) : DateTime.now(),
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
    );
  }

  /// Convert model to JSON
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

  /// Convert entity to model
  factory ImmunizationModel.fromEntity(Immunization immunization) {
    return ImmunizationModel(
      id: immunization.id,
      patientId: immunization.patientId,
      providerId: immunization.providerId,
      title: immunization.title,
      body: immunization.body,
      lastUpdated: immunization.lastUpdated,
      createdAt: immunization.createdAt,
    );
  }

  /// Optional: copyWith method
  ImmunizationModel copyWith({
    String? id,
    String? patientId,
    String? providerId,
    String? title,
    String? body,
    DateTime? lastUpdated,
    DateTime? createdAt,
  }) {
    return ImmunizationModel(
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
