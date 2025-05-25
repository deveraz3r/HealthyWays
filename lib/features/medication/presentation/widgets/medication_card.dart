import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthyways/core/theme/app_pallete.dart';
import 'package:healthyways/features/medication/presentation/controllers/medication_controller.dart';
import 'package:intl/intl.dart';

class MedicationCard extends StatelessWidget {
  final dynamic medication;
  const MedicationCard({super.key, required this.medication});

  void _showTimeSelectionDialog(
    BuildContext context,
    MedicationController controller,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: AppPallete.backgroundColor2,
            title: const Text('Select Time'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.access_time),
                  title: const Text('Now'),
                  onTap: () {
                    controller.toggleMedicationStatusById(
                      id: medication.id,
                      timeTaken: DateTime.now(),
                    );
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.schedule),
                  title: const Text('Allocated Time'),
                  onTap: () {
                    controller.toggleMedicationStatusById(
                      id: medication.id,
                      timeTaken: medication.allocatedTime,
                    );
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.edit_calendar),
                  title: const Text('Custom Time'),
                  onTap: () async {
                    Navigator.pop(context);
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(
                        medication.allocatedTime,
                      ),
                    );
                    if (time != null) {
                      final now = DateTime.now();
                      final customTime = DateTime(
                        now.year,
                        now.month,
                        now.day,
                        time.hour,
                        time.minute,
                      );
                      controller.toggleMedicationStatusById(
                        id: medication.id,
                        timeTaken: customTime,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
    );
  }

  void _handleTap(BuildContext context, MedicationController controller) {
    // If medication is already taken, just unmark it
    if (medication.isTaken) {
      controller.toggleMedicationStatusById(
        id: medication.id,
        timeTaken: null, // Set to null when unmarking
      );
    } else {
      // If not taken, show time selection dialog
      _showTimeSelectionDialog(context, controller);
    }
  }

  Widget _buildAssignedBy() {
    // If doctor information is available (not null)
    if (medication.doctorFName != null && medication.doctorFName.isNotEmpty) {
      return Row(
        children: [
          if (medication.doctorImageUrl != null &&
              medication.doctorImageUrl.isNotEmpty)
            CircleAvatar(
              radius: 8,
              backgroundImage: NetworkImage(medication.doctorImageUrl!),
            )
          else
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: AppPallete.backgroundColor2,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.person, size: 12, color: AppPallete.gradient1),
            ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              'Dr. ${medication.doctorFName}',
              style: TextStyle(fontSize: 12, color: AppPallete.greyColor),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
    }

    // If self-assigned (doctor info is null)
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: AppPallete.backgroundColor2,
            shape: BoxShape.circle,
            border: Border.all(
              color: AppPallete.greyColor.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Icon(
            Icons.person_outline,
            size: 12,
            color: AppPallete.greyColor,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          'Self-assigned',
          style: TextStyle(
            fontSize: 12,
            color: AppPallete.greyColor,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MedicationController>();

    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 280, maxWidth: 400),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppPallete.gradient1.withOpacity(0.2),
                AppPallete.backgroundColor2,
              ],
            ),
          ),
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Row with icon and medicine name/dosage
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppPallete.backgroundColor2,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.medication,
                      size: 30,
                      color: AppPallete.gradient1,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          medication.medicine.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${medication.medicine.dosage} ${medication.medicine.unit}',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppPallete.greyColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              _buildAssignedBy(), // Keep existing method
              const SizedBox(height: 8),

              /// Mark as taken button
              InkWell(
                onTap: () => _handleTap(context, controller),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 8,
                  ),
                  decoration: BoxDecoration(
                    color:
                        medication.isTaken
                            ? AppPallete.backgroundColor2
                            : AppPallete.gradient1.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color:
                          medication.isTaken
                              ? AppPallete.greyColor.withOpacity(0.3)
                              : AppPallete.gradient1.withOpacity(0.3),
                    ),
                  ),
                  child:
                      medication.isTaken && medication.takenTime != null
                          ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.check,
                                size: 14,
                                color: AppPallete.greyColor,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Taken at ${DateFormat('hh:mm a').format(medication.takenTime!)}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppPallete.greyColor,
                                ),
                              ),
                            ],
                          )
                          : Text(
                            'Mark as taken',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppPallete.gradient1,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
