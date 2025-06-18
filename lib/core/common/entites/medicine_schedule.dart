import 'package:flutter/material.dart';
import 'package:healthyways/core/common/custom_types/repetition_type.dart';

class MedicineSchedule {
  final String medicineId;
  final List<IntakeInstruction> intakeInstruction;
  final RepetitionType repetitionType;
  final List<String>? weekdays;
  final List<DateTime>? customDates;

  const MedicineSchedule({
    required this.medicineId,
    required this.intakeInstruction,
    required this.repetitionType,
    this.weekdays,
    this.customDates,
  });
}

class IntakeInstruction {
  final TimeOfDay time;
  final double quantity;

  IntakeInstruction({required this.time, required this.quantity});
}
