import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthyways/core/common/controllers/app_profile_controller.dart';
import 'package:healthyways/core/common/custom_types/my_measurements.dart';
import 'package:healthyways/core/theme/app_pallete.dart';
import 'package:healthyways/features/measurements/domain/entites/measurement_entry.dart';
import 'package:healthyways/features/patient/presentation/controllers/patient_controller.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class PatientMeasurementCard extends StatefulWidget {
  final MyMeasurements measurement;
  final String time;

  const PatientMeasurementCard({super.key, required this.measurement, required this.time});

  @override
  State<PatientMeasurementCard> createState() => _PatientMeasurementCardState();
}

class _PatientMeasurementCardState extends State<PatientMeasurementCard> {
  final _patientController = Get.find<PatientController>();
  final _appProfileController = Get.find<AppProfileController>();
  MeasurementEntry? _todaysMeasurement;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTodaysMeasurement();
  }

  Future<void> _loadTodaysMeasurement() async {
    final entries = await _patientController.getMeasurementEntries(
      patientId: _appProfileController.profile.data!.uid,
      measurementId: widget.measurement.id,
    );

    // Find today's measurement if exists
    final now = DateTime.now();
    _todaysMeasurement = entries.firstWhereOrNull(
      (entry) =>
          entry.createdAt.year == now.year && entry.createdAt.month == now.month && entry.createdAt.day == now.day,
    );

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showAddEntryDialog(BuildContext context) {
    final valueController = TextEditingController();
    final noteController = TextEditingController();
    final patientController = Get.find<PatientController>();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Add ${widget.measurement.id} Entry'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: valueController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(labelText: 'Value '),
                ),
                const SizedBox(height: 12),
                TextField(controller: noteController, decoration: const InputDecoration(labelText: 'Note (optional)')),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
              ElevatedButton(
                onPressed: () async {
                  final value = valueController.text.trim();
                  final note = noteController.text.trim();

                  if (value.isEmpty) return;

                  final entry = MeasurementEntry(
                    id: const Uuid().v4(),
                    measurementId: widget.measurement.id,
                    patientId: Get.find<AppProfileController>().profile.data!.uid,
                    value: value,
                    note: note,
                    lastUpdated: DateTime.now(),
                    createdAt: DateTime.now(),
                  );

                  await patientController.addMeasurementEntry(measurementEntry: entry);

                  Navigator.pop(context);
                },
                child: const Text('Add'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                    color: AppPallete.backgroundColor2,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.monitor_heart, size: 32, color: AppPallete.gradient1),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.measurement.id, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.access_time, size: 16, color: AppPallete.greyColor),
                          const SizedBox(width: 4),
                          Text('Take at ${widget.time}', style: TextStyle(fontSize: 15, color: AppPallete.greyColor)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: _todaysMeasurement == null ? () => _showAddEntryDialog(context) : null,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color:
                      _todaysMeasurement != null
                          ? AppPallete.backgroundColor2
                          : AppPallete.gradient1.withAlpha((0.1 * 255).round()),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color:
                        _todaysMeasurement != null
                            ? AppPallete.greyColor.withAlpha((0.3 * 255).round())
                            : AppPallete.gradient1.withAlpha((0.3 * 255).round()),
                  ),
                ),
                child:
                    _isLoading
                        ? const Center(
                          child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                        )
                        : _todaysMeasurement != null
                        ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check, size: 18, color: AppPallete.greyColor),
                            const SizedBox(width: 8),
                            Text(
                              'Taken at ${DateFormat('hh:mm a').format(_todaysMeasurement!.createdAt)}',
                              style: TextStyle(fontSize: 15, color: AppPallete.greyColor),
                            ),
                          ],
                        )
                        : const Text(
                          'Enter Measurement',
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
