import 'package:healthyways/core/common/entites/medication.dart';

class MedicationModel extends Medication {
  MedicationModel({
    required super.id,
    required super.medicineId,
    required super.assignedTo,
    super.assignedBy,
    required super.isActive,
    required super.quantity,
    required super.allocatedTime,
    required super.isTaken,
    super.takenTime,
  });

  factory MedicationModel.fromJson(Map<String, dynamic> json) {
    return MedicationModel(
      id: json["id"] ?? '',
      medicineId: json["medicineId"] ?? '',
      assignedTo: json['assignedTo'] ?? '',
      assignedBy: json['assignedBy'],
      isActive: json['isActive'] ?? false,
      quantity: json['quantity'] ?? 0,
      allocatedTime: DateTime.parse(json['allocatedTime']),
      isTaken: json['isTaken'] ?? false,
      takenTime: json['takenTime'] != null ? DateTime.parse(json['takenTime']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'medicineId': medicineId,
      'assignedTo': assignedTo,
      'assignedBy': assignedBy,
      'isActive': isActive,
      'quantity': quantity,
      'allocatedTime': allocatedTime.toIso8601String(),
      'isTaken': isTaken,
      'takenTime': takenTime?.toIso8601String(),
    };
  }

  MedicationModel copyWith({
    String? id,
    String? medicineId,
    String? assignedTo,
    String? assignedBy,
    String? doctorFName,
    String? doctorImageUrl,
    bool? isActive,
    int? quantity,
    DateTime? allocatedTime,
    bool? isTaken,
    DateTime? takenTime,
  }) {
    return MedicationModel(
      id: id ?? this.id,
      medicineId: medicineId ?? this.medicineId,
      assignedTo: assignedTo ?? this.assignedTo,
      assignedBy: assignedBy ?? this.assignedBy,
      isActive: isActive ?? this.isActive,
      quantity: quantity ?? this.quantity,
      allocatedTime: allocatedTime ?? this.allocatedTime,
      isTaken: isTaken ?? this.isTaken,
      takenTime: takenTime ?? this.takenTime,
    );
  }
}
