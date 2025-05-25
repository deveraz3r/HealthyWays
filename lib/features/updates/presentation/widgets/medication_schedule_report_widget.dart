import 'package:flutter/material.dart';
import 'package:healthyways/core/theme/app_pallete.dart';
import 'package:healthyways/features/updates/domain/entites/medications_schedule_report.dart';
import 'package:intl/intl.dart';

class MedicationScheduleCard extends StatelessWidget {
  final MedicationScheduleReport schedule;

  const MedicationScheduleCard({super.key, required this.schedule});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color:
                        schedule.isActive
                            ? AppPallete.gradient1.withOpacity(0.1)
                            : AppPallete.greyColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    schedule.isActive ? 'Active' : 'Inactive',
                    style: TextStyle(
                      color:
                          schedule.isActive
                              ? AppPallete.gradient1
                              : AppPallete.greyColor,
                      fontSize: 12,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  'Until ${DateFormat('MMM d, y').format(schedule.endTime)}',
                  style: TextStyle(color: AppPallete.greyColor, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              schedule.medicine.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  '${schedule.quantity} ${schedule.medicine.unit}',
                  style: const TextStyle(fontSize: 16),
                ),
                const Text(' • '),
                Text(schedule.frequency, style: const TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  Icons.person_outline,
                  size: 16,
                  color: AppPallete.greyColor,
                ),
                const SizedBox(width: 4),
                Text(
                  'Assigned by ${schedule.assignedBy}',
                  style: TextStyle(color: AppPallete.greyColor, fontSize: 14),
                ),
                const Text(' • '),
                Text(
                  schedule.assignerRole,
                  style: TextStyle(color: AppPallete.greyColor, fontSize: 14),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
