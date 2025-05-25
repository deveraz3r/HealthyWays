import 'package:healthyways/core/common/entites/medicine.dart';

class MedicationScheduleReport {
  final String id;
  final Medicine medicine;
  final String assignedTo;
  final String assignedBy;
  final String assignerRole;
  final int quantity;
  final String frequency;
  final DateTime endTime;
  final bool isActive;

  const MedicationScheduleReport({
    required this.id,
    required this.medicine,
    required this.assignedTo,
    required this.assignedBy,
    required this.assignerRole,
    required this.quantity,
    required this.frequency,
    required this.endTime,
    required this.isActive,
  });
}
