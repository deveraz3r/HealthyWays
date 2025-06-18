import 'package:healthyways/core/common/entites/medicine_schedule.dart';

class AssignedMedicationReport {
  final String id; //uuid for medication report
  final String assignedTo;
  final String assignedBy;
  final List<MedicineSchedule> medicines;
  final DateTime startDate;
  final DateTime endDate;

  AssignedMedicationReport({
    required this.id,
    required this.assignedTo,
    required this.assignedBy,
    required this.medicines,
    required this.startDate,
    required this.endDate,
  });
}
