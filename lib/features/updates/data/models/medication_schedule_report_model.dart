import 'package:healthyways/features/medication/data/models/medicine_model.dart';
import 'package:healthyways/features/updates/domain/entites/medications_schedule_report.dart';

class MedicationScheduleReportModel extends MedicationScheduleReport {
  const MedicationScheduleReportModel({
    required super.id,
    required super.medicine,
    required super.assignedTo,
    required super.assignedBy,
    required super.assignerRole,
    required super.quantity,
    required super.frequency,
    required super.endTime,
    required super.isActive,
  });

  factory MedicationScheduleReportModel.fromJson(Map<String, dynamic> json) {
    return MedicationScheduleReportModel(
      id: json['id'] ?? '',
      medicine: MedicineModel.fromJson(json['medicine'] ?? {}),
      assignedTo: json['assignedTo'] ?? '',
      assignedBy: json['assignedBy'] ?? '',
      assignerRole: json['assignerRole'] ?? '',
      quantity: json['quantity'] ?? 0,
      frequency: json['frequency'] ?? '',
      endTime: DateTime.parse(
        json['endTime'] ?? DateTime.now().toIso8601String(),
      ),
      isActive: json['isActive'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'medicine': (medicine as MedicineModel).toJson(),
      'assignedTo': assignedTo,
      'assignedBy': assignedBy,
      'assignerRole': assignerRole,
      'quantity': quantity,
      'frequency': frequency,
      'endTime': endTime.toIso8601String(),
      'isActive': isActive,
    };
  }
}
