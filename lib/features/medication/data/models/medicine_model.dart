import 'package:healthyways/core/common/custom_types/shape.dart';
import 'package:healthyways/core/common/entites/medicine.dart';

class MedicineModel extends Medicine {
  MedicineModel({
    required super.id,
    required super.name,
    required super.dosage,
    required super.unit,
    required super.shape,
  });

  factory MedicineModel.fromJson(Map<String, dynamic> json) {
    return MedicineModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      dosage: json['dosage'] ?? 0,
      unit: json['unit'] ?? '',
      shape: Shape.fromJson(json['shape'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'dosage': dosage,
      'unit': unit,
      'shape': shape.toJson(),
    };
  }
}
