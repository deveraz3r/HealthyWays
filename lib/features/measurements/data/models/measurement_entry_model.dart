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
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'measurementId': measurementId,
      'patientId': patientId,
      'value': value,
      'note': note,
      'lastUpdated': lastUpdated.millisecondsSinceEpoch,
    };
  }

  factory MeasurementEntryModel.fromMap(Map<String, dynamic> map) {
    return MeasurementEntryModel(
      id: map['id'] as String,
      measurementId: map['measurementId'] as String,
      patientId: map['patientId'] as String,
      value: map['value'] as String,
      note: map['note'] as String,
      lastUpdated: DateTime.fromMillisecondsSinceEpoch(
        map['lastUpdated'] as int,
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory MeasurementEntryModel.fromJson(String source) =>
      MeasurementEntryModel.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );
}
