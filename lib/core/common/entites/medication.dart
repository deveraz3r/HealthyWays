class Medication {
  final String id;
  final String medicineId;
  final String assignedTo; // patient ID
  final String? assignedBy; // doctor ID or null if self-assigned
  final bool isActive;
  final int quantity;
  final DateTime allocatedTime;
  final bool isTaken;
  final DateTime? takenTime;

  Medication({
    required this.id,
    required this.medicineId,
    required this.assignedTo,
    this.assignedBy,
    required this.isActive,
    required this.quantity,
    required this.allocatedTime,
    required this.isTaken,
    this.takenTime,
  });
}
