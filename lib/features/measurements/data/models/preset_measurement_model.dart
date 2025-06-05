import 'package:healthyways/features/measurements/domain/entites/preset_measurement.dart';

class PresetMeasurementModel extends PresetMeasurement {
  PresetMeasurementModel({required super.id, required super.title, required super.category, required super.unit});

  factory PresetMeasurementModel.fromJson(Map<String, dynamic> json) {
    return PresetMeasurementModel(
      id: json['id'] as String,
      title: json['title'] as String,
      category: json['category'] as String,
      unit: json['unit'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title, 'category': category, 'unit': unit};
  }
}
