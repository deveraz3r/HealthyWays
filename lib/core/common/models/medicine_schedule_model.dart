import 'package:healthyways/core/common/custom_types/repetition_type.dart';
import 'package:healthyways/core/common/models/intake_instructions_model.dart';
import 'package:healthyways/core/common/entites/medicine_schedule.dart';

class MedicineScheduleModel extends MedicineSchedule {
  const MedicineScheduleModel({
    required super.medicineId,
    required List<IntakeInstructionModel> intakeInstruction,
    required super.repetitionType,
    super.weekdays,
    super.customDates,
  }) : super(intakeInstruction: intakeInstruction);

  factory MedicineScheduleModel.fromJson(Map<String, dynamic> json) {
    return MedicineScheduleModel(
      medicineId: json['medicineId'],
      intakeInstruction: (json['intakeInstruction'] as List).map((e) => IntakeInstructionModel.fromJson(e)).toList(),
      repetitionType: RepetitionType.values.firstWhere((e) => e.toString().split('.').last == json['repetitionType']),
      weekdays: json['weekdays'] != null ? List<String>.from(json['weekdays']) : null,
      customDates:
          json['customDates'] != null ? List<String>.from(json['customDates']).map(DateTime.parse).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'medicineId': medicineId,
      'intakeInstruction': intakeInstruction.map((e) => (e as IntakeInstructionModel).toJson()).toList(),
      'repetitionType': repetitionType.toString().split('.').last,
      if (weekdays != null) 'weekdays': weekdays,
      if (customDates != null) 'customDates': customDates!.map((e) => e.toIso8601String()).toList(),
    };
  }

  factory MedicineScheduleModel.fromEntity(MedicineSchedule entity) {
    return MedicineScheduleModel(
      medicineId: entity.medicineId,
      intakeInstruction:
          entity.intakeInstruction.map((e) => IntakeInstructionModel(time: e.time, quantity: e.quantity)).toList(),
      repetitionType: entity.repetitionType,
      weekdays: entity.weekdays,
      customDates: entity.customDates,
    );
  }
}
