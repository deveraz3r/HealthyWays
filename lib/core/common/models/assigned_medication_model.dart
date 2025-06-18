import 'package:healthyways/core/common/entites/assigned_medication_report.dart';
import 'medicine_schedule_model.dart';

class AssignedMedicationReportModel extends AssignedMedicationReport {
  AssignedMedicationReportModel({
    required super.id,
    required super.assignedTo,
    required super.assignedBy,
    required List<MedicineScheduleModel> medicines,
    required super.startDate,
    required super.endDate,
  }) : super(medicines: medicines);

  factory AssignedMedicationReportModel.fromJson(Map<String, dynamic> json) {
    return AssignedMedicationReportModel(
      id: json['id'],
      assignedTo: json['assignedTo'],
      assignedBy: json['assignedBy'],
      medicines: (json['medicines'] as List).map((e) => MedicineScheduleModel.fromJson(e)).toList(),
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'assignedTo': assignedTo,
      'assignedBy': assignedBy,
      'medicines': medicines.map((e) => (e as MedicineScheduleModel).toJson()).toList(),
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
    };
  }
}
