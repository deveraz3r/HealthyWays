import 'package:flutter/material.dart' as material;
import 'package:healthyways/core/common/custom_types/repetition_type.dart';
import 'package:healthyways/core/common/custom_types/visibility.dart';

class MyMeasurements {
  String id;
  Visibility visiblity;
  bool isActive;
  final RepetitionType repetitionType;
  final material.TimeOfDay time;
  final List<String>? weekdays;
  final List<DateTime>? customDates;

  MyMeasurements({
    required this.id,
    required this.visiblity,
    required this.isActive,
    required this.repetitionType,
    required this.time,
    this.weekdays,
    this.customDates,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'visiblity': visiblity.toJson(),
      'isActive': isActive,
      'repetitionType': repetitionType.name,
      'time': '${time.hour}:${time.minute}', // serialize time
      'weekdays': weekdays,
      'customDates': customDates?.map((date) => date.toIso8601String()).toList(),
    };
  }

  factory MyMeasurements.fromJson(Map<String, dynamic> json) {
    final timeParts = (json['time'] as String?)?.split(':');
    final time =
        (timeParts != null && timeParts.length == 2)
            ? material.TimeOfDay(hour: int.tryParse(timeParts[0]) ?? 0, minute: int.tryParse(timeParts[1]) ?? 0)
            : material.TimeOfDay(hour: 0, minute: 0);

    return MyMeasurements(
      id: json['id'] ?? "",
      visiblity: Visibility.fromJson(json['visiblity']),
      isActive: json['isActive'] ?? false,
      repetitionType: RepetitionTypeExtension.fromString(json['repetitionType']),
      time: time,
      weekdays: (json['weekdays'] as List<dynamic>?)?.map((e) => e as String).toList(),
      customDates: (json['customDates'] as List<dynamic>?)?.map((e) => DateTime.parse(e as String)).toList(),
    );
  }

  MyMeasurements copyWith({
    String? id,
    Visibility? visiblity,
    bool? isActive,
    RepetitionType? repetitionType,
    material.TimeOfDay? time,
    List<String>? weekdays,
    List<DateTime>? customDates,
  }) {
    return MyMeasurements(
      id: id ?? this.id,
      visiblity: visiblity ?? this.visiblity,
      isActive: isActive ?? this.isActive,
      repetitionType: repetitionType ?? this.repetitionType,
      time: time ?? this.time,
      weekdays: weekdays ?? this.weekdays,
      customDates: customDates ?? this.customDates,
    );
  }
}
