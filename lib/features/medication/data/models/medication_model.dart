import 'package:healthyways/core/common/entites/medication.dart';
import 'package:healthyways/features/medication/data/models/medicine_model.dart';

class MedicationModel extends Medication {
  MedicationModel({
    required super.id,
    required super.medicine,
    required super.assignedTo,
    super.assignedBy,
    super.doctorFName,
    super.doctorImageUrl,
    required super.isActive,
    required super.quantity,
    required super.allocatedTime,
    required super.isTaken,
    super.takenTime,
  });

  factory MedicationModel.fromJson(Map<String, dynamic> json) {
    final medicineJson = Map<String, dynamic>.from(json);
    medicineJson["id"] = json["medicineId"];

    return MedicationModel(
      id: json["id"] ?? '',
      medicine: MedicineModel.fromJson(medicineJson),
      assignedTo: json['assignedTo'] ?? '',
      assignedBy: json['assignedBy'],
      doctorFName: json['doctorFName'],
      doctorImageUrl: json['doctorImageUrl'],
      isActive: json['isActive'] ?? false,
      quantity: json['quantity'] ?? 0,
      allocatedTime: DateTime.parse(json['allocatedTime']),
      isTaken: json['isTaken'] ?? false,
      takenTime:
          json['takenTime'] != null ? DateTime.parse(json['takenTime']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final medicineMap = (medicine as MedicineModel).toJson();

    return {
      'id': id,
      'medicineId': medicineMap['id'],
      'name': medicineMap['name'],
      'dosage': medicineMap['dosage'],
      'unit': medicineMap['unit'],
      'shape': medicineMap['shape'],
      'assignedTo': assignedTo,
      'assignedBy': assignedBy,
      'doctorFName': doctorFName,
      'doctorImageUrl': doctorImageUrl,
      'isActive': isActive,
      'quantity': quantity,
      'allocatedTime': allocatedTime.toIso8601String(),
      'isTaken': isTaken,
      'takenTime': takenTime?.toIso8601String(),
    };
  }

  MedicationModel copyWith({
    String? id,
    MedicineModel? medicine,
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
      medicine: medicine ?? this.medicine,
      assignedTo: assignedTo ?? this.assignedTo,
      assignedBy: assignedBy ?? this.assignedBy,
      doctorFName: doctorFName ?? this.doctorFName,
      doctorImageUrl: doctorImageUrl ?? this.doctorImageUrl,
      isActive: isActive ?? this.isActive,
      quantity: quantity ?? this.quantity,
      allocatedTime: allocatedTime ?? this.allocatedTime,
      isTaken: isTaken ?? this.isTaken,
      takenTime: takenTime ?? this.takenTime,
    );
  }
}
