import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthyways/core/common/entites/medication.dart';
import 'package:healthyways/core/common/entites/medicine.dart';
import 'package:healthyways/core/theme/app_pallete.dart';
import 'package:healthyways/features/patient/presentation/controllers/patient_controller.dart';
import 'package:intl/intl.dart';

class MedicationCard extends StatefulWidget {
  final Medication medication;
  const MedicationCard({super.key, required this.medication});

  @override
  State<MedicationCard> createState() => _MedicationCardState();
}

class _MedicationCardState extends State<MedicationCard> {
  // Remove medication controller, we'll use patient controller
  final _patientController = Get.find<PatientController>();
  Medicine? _medicine;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMedicineDetails();
  }

  Future<void> _loadMedicineDetails() async {
    final medicine = await _patientController.getMedicineById(widget.medication.medicineId);
    if (mounted) {
      setState(() {
        _medicine = medicine;
        _isLoading = false;
      });
    }
  }

  void _handleTap(BuildContext context) {
    if (widget.medication.isTaken) {
      _patientController.toggleMedicationStatusById(
        id: widget.medication.id,
        timeTaken: null,
        medication: widget.medication, // Pass current medication state
      );
    } else {
      _showTimeSelectionDialog(context);
    }
  }

  void _showTimeSelectionDialog(BuildContext context) {
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
                    _patientController.toggleMedicationStatusById(
                      id: widget.medication.id,
                      timeTaken: DateTime.now(),
                      medication: widget.medication,
                    );
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.schedule),
                  title: const Text('Allocated Time'),
                  onTap: () {
                    _patientController.toggleMedicationStatusById(
                      id: widget.medication.id,
                      timeTaken: widget.medication.allocatedTime,
                      medication: widget.medication,
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
                      initialTime: TimeOfDay.fromDateTime(widget.medication.allocatedTime),
                    );
                    if (time != null) {
                      final now = DateTime.now();
                      final customTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);
                      _patientController.toggleMedicationStatusById(
                        id: widget.medication.id,
                        timeTaken: customTime,
                        medication: widget.medication,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Remove medication controller from build
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppPallete.gradient1.withAlpha((0.2 * 255).round()), AppPallete.backgroundColor2],
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color:
                        _isLoading || _medicine == null
                            ? AppPallete.backgroundColor2
                            : Color(int.parse(_medicine!.shape.primaryColorHex.substring(1, 7), radix: 16)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.medication, color: Colors.white),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _isLoading
                              ? const SizedBox(width: 100, child: LinearProgressIndicator())
                              : Text(
                                _medicine?.name ?? 'Unknown Medicine',
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                          const SizedBox(width: 4),
                          if (!_isLoading && _medicine != null)
                            Text(
                              ' ${_medicine!.dosage} ${_medicine!.unit}',
                              style: TextStyle(fontSize: 15, color: AppPallete.greyColor),
                            ),
                        ],
                      ),
                      const SizedBox(width: 4),
                      Row(
                        children: [
                          const Icon(Icons.access_time, size: 16, color: AppPallete.greyColor),

                          Text(
                            ' Take at: ${DateFormat('hh:mm a').format(widget.medication.allocatedTime)}',
                            style: TextStyle(fontSize: 15, color: AppPallete.greyColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // const SizedBox(height: 16),
            // _buildAssignedBy(),
            const SizedBox(height: 12),
            InkWell(
              onTap: () => _handleTap(context), // Updated to use local method
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color:
                      widget.medication.isTaken
                          ? AppPallete.backgroundColor2
                          : AppPallete.gradient1.withAlpha((0.1 * 255).round()),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color:
                        widget.medication.isTaken
                            ? AppPallete.greyColor.withAlpha((0.3 * 255).round())
                            : AppPallete.gradient1.withAlpha((0.3 * 255).round()),
                  ),
                ),
                child:
                    widget.medication.isTaken && widget.medication.takenTime != null
                        ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check, size: 18, color: AppPallete.greyColor),
                            const SizedBox(width: 8),
                            Text(
                              'Taken at ${DateFormat('hh:mm a').format(widget.medication.takenTime!)}',
                              style: TextStyle(fontSize: 15, color: AppPallete.greyColor),
                            ),
                          ],
                        )
                        : const Text(
                          'Mark as taken',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 15, color: AppPallete.gradient1, fontWeight: FontWeight.w600),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
