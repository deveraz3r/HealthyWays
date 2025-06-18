import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthyways/core/common/controllers/app_profile_controller.dart';
import 'package:healthyways/core/common/widgets/loader.dart';
import 'package:healthyways/core/theme/app_pallete.dart';
import 'package:healthyways/features/measurements/domain/entites/preset_measurement.dart';
import 'package:healthyways/features/measurements/presentation/controllers/measurement_controller.dart';
import 'package:healthyways/features/measurements/presentation/pages/measurement_settings_page.dart';
import 'package:healthyways/features/measurements/presentation/pages/visibility_details_page.dart';
import 'package:healthyways/features/measurements/presentation/widgets/measurement_entry_card.dart';
import 'package:uuid/uuid.dart';
import 'package:healthyways/features/measurements/domain/entites/measurement_entry.dart';

class MeasurementDetailsPage extends StatefulWidget {
  static route(PresetMeasurement measurement) =>
      MaterialPageRoute(builder: (context) => MeasurementDetailsPage(measurement: measurement));

  final PresetMeasurement measurement;
  const MeasurementDetailsPage({super.key, required this.measurement});

  @override
  State<MeasurementDetailsPage> createState() => _MeasurementDetailsPageState();
}

class _MeasurementDetailsPageState extends State<MeasurementDetailsPage> {
  final MeasurementController _measurementController = Get.find();
  final AppProfileController _appProfileController = Get.find();

  @override
  void initState() {
    _loadEntries();
    super.initState();
  }

  void _loadEntries() {
    _measurementController.getMeasurementEntries(
      patientId: _appProfileController.profile.data!.uid,
      measurementId: widget.measurement.id,
    );
  }

  void _showAddMeasurementEntryDialog() {
    final TextEditingController valueController = TextEditingController();
    final TextEditingController noteController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Add ${widget.measurement.title} Entry'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: valueController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(labelText: 'Value (${widget.measurement.unit})'),
                ),
                SizedBox(height: 12),
                TextField(controller: noteController, decoration: InputDecoration(labelText: 'Note (optional)')),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
              ElevatedButton(
                onPressed: () async {
                  final value = valueController.text.trim();
                  final note = noteController.text.trim();

                  if (value.isEmpty) return;

                  final entry = MeasurementEntry(
                    id: const Uuid().v4(),
                    measurementId: widget.measurement.id,
                    patientId: _appProfileController.profile.data!.uid,
                    value: value,
                    note: note,
                    lastUpdated: DateTime.now(),
                    createdAt: DateTime.now(),
                  );

                  await _measurementController.addMeasurementEntry(measurementEntry: entry);

                  Navigator.pop(context); // Close dialog
                },
                child: Text('Add'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.measurement.title),
        backgroundColor: AppPallete.backgroundColor2,
        actions: [
          IconButton(
            onPressed: () => Navigator.push(context, MeasurementSettingsPage.route(measurement: widget.measurement)),
            icon: Icon(Icons.settings),
          ),
          IconButton(onPressed: _showAddMeasurementEntryDialog, icon: Icon(CupertinoIcons.add_circled)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          if (_measurementController.measurementEntries.isLoading) {
            return Loader();
          } else if (_measurementController.measurementEntries.hasError) {
            return Center(child: Text(_measurementController.measurementEntries.error!.message));
          }

          final entries = _measurementController.measurementEntries.data ?? [];

          return entries.isEmpty
              ? Center(child: Text('No entries yet.'))
              : ListView.separated(
                itemCount: entries.length,
                separatorBuilder: (context, index) => Divider(),
                itemBuilder: (context, index) {
                  final measurementEntry = entries[index];
                  return MeasurementEntryCard(measurementEntry: measurementEntry);
                },
              );
        }),
      ),
    );
  }
}
