import 'package:healthyways/core/common/entites/medicine.dart';

class Medication {
  final String id;
  final Medicine medicine;
  final String assignedTo; // patient ID
  final String? assignedBy; // doctor ID or null if self-assigned
  final String? doctorFName;
  final String? doctorImageUrl;
  final bool isActive;
  final int quantity;
  final DateTime allocatedTime;
  final bool isTaken;
  final DateTime? takenTime;

  Medication({
    required this.id,
    required this.medicine,
    required this.assignedTo,
    this.assignedBy,
    this.doctorFName,
    this.doctorImageUrl,
    required this.isActive,
    required this.quantity,
    required this.allocatedTime,
    required this.isTaken,
    this.takenTime,
  });
}
