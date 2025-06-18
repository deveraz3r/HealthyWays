import 'dart:convert';

import 'package:healthyways/features/measurements/domain/entites/measurement_entry.dart';

class MeasurementEntryModel extends MeasurementEntry {
  MeasurementEntryModel({
    required super.id,
    required super.measurementId,
    required super.patientId,
    required super.value,
    required super.note,
    required super.lastUpdated,
    required super.createdAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'measurementId': measurementId,
      'patientId': patientId,
      'value': value,
      'note': note,
      'lastUpdated': lastUpdated.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory MeasurementEntryModel.fromMap(Map<String, dynamic> map) {
    return MeasurementEntryModel(
      id: map['id'] as String,
      measurementId: map['measurementId'] as String,
      patientId: map['patientId'] as String,
      value: map['value'] as String,
      note: map['note'] as String,
      lastUpdated: DateTime.parse(map['lastUpdated']),
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory MeasurementEntryModel.fromJson(String source) =>
      MeasurementEntryModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
