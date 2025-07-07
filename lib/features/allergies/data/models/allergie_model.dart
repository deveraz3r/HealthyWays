import 'package:healthyways/features/allergies/domain/entities/allergy.dart';

class AllergieModel extends Allergy {
  const AllergieModel({
    required super.id,
    required super.patientId,
    super.providerId,
    required super.title,
    required super.body,
    required super.lastUpdated,
    required super.createdAt,
  });

  /// Convert JSON to ImmunizationModel
  factory AllergieModel.fromJson(Map<String, dynamic> json) {
    return AllergieModel(
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
  factory AllergieModel.fromEntity(Allergy allergie) {
    return AllergieModel(
      id: allergie.id,
      patientId: allergie.patientId,
      providerId: allergie.providerId,
      title: allergie.title,
      body: allergie.body,
      lastUpdated: allergie.lastUpdated,
      createdAt: allergie.createdAt,
    );
  }

  /// Optional: copyWith method
  AllergieModel copyWith({
    String? id,
    String? patientId,
    String? providerId,
    String? title,
    String? body,
    DateTime? lastUpdated,
    DateTime? createdAt,
  }) {
    return AllergieModel(
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
