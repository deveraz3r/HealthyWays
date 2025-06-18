import 'package:flutter/material.dart';
import 'package:healthyways/core/common/entites/medicine_schedule.dart';

class IntakeInstructionModel extends IntakeInstruction {
  IntakeInstructionModel({required super.time, required super.quantity});

  factory IntakeInstructionModel.fromJson(Map<String, dynamic> json) {
    final timeParts = json['time'].split(':');
    return IntakeInstructionModel(
      time: TimeOfDay(hour: int.parse(timeParts[0]), minute: int.parse(timeParts[1])),
      quantity: (json['quantity'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time': '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
      'quantity': quantity,
    };
  }
}
