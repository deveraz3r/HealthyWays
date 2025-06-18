import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthyways/core/common/custom_types/my_measurements.dart';
import 'package:healthyways/core/common/custom_types/repetition_type.dart';
import 'package:healthyways/core/common/custom_types/visibility.dart' as custom_visibility;
import 'package:healthyways/core/common/custom_types/visibility_type.dart';
import 'package:healthyways/core/theme/app_pallete.dart';
import 'package:healthyways/features/measurements/domain/entites/preset_measurement.dart';
import 'package:healthyways/features/measurements/presentation/controllers/measurement_controller.dart';
import 'package:intl/intl.dart';

class MyMeasurementReminderSettingsPage extends StatefulWidget {
  static route(PresetMeasurement measurement) =>
      MaterialPageRoute(builder: (_) => MyMeasurementReminderSettingsPage(measurement: measurement));

  final PresetMeasurement measurement;
  const MyMeasurementReminderSettingsPage({super.key, required this.measurement});

  @override
  State<MyMeasurementReminderSettingsPage> createState() => _MyMeasurementReminderSettingsPageState();
}

class _MyMeasurementReminderSettingsPageState extends State<MyMeasurementReminderSettingsPage> {
  final _controller = Get.find<MeasurementController>();

  late TimeOfDay _selectedTime;
  late String _repetitionType;
  final _selectedWeekdays = <String>[];
  final _customDates = <DateTime>[];

  @override
  void initState() {
    super.initState();
    // Get current settings from user's profile
    final currentMeasurement = _controller.getCurrentMeasurementSettings(widget.measurement.id);
    _selectedTime = currentMeasurement?.time ?? TimeOfDay(hour: 12, minute: 0);
    _repetitionType = currentMeasurement?.repetitionType.name ?? RepetitionType.none.name;
    _selectedWeekdays.addAll(currentMeasurement?.weekdays ?? []);
    _customDates.addAll(currentMeasurement?.customDates ?? []);
  }

  void _updateSettings() {
    final updatedMeasurement = MyMeasurements(
      id: widget.measurement.id,
      visiblity:
          (_controller.getCurrentMeasurementSettings(widget.measurement.id)?.visiblity
              as custom_visibility.Visibility?) ??
          custom_visibility.Visibility(type: VisibilityType.private, customAccess: []),
      isActive: true,
      repetitionType: RepetitionTypeExtension.fromString(_repetitionType),
      time: _selectedTime,
      weekdays: _repetitionType == RepetitionType.weekdays.name ? _selectedWeekdays : null,
      customDates: _repetitionType == RepetitionType.customDates.name ? _customDates : null,
    );

    _controller.updateMyMeasurementReminderSettings(myMeasurement: updatedMeasurement);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reminder Settings'), backgroundColor: AppPallete.backgroundColor2),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Time Picker
            InkWell(
              onTap: () async {
                final time = await showTimePicker(context: context, initialTime: _selectedTime);
                if (time != null) {
                  setState(() => _selectedTime = time);
                }
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Reminder Time',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text(_selectedTime.format(context)), const Icon(Icons.access_time)],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Repetition Type Dropdown
            DropdownButtonFormField<String>(
              value: _repetitionType,
              decoration: InputDecoration(
                labelText: 'Repeat',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              items:
                  RepetitionType.values
                      .map((type) => DropdownMenuItem(value: type.name, child: Text(type.name)))
                      .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _repetitionType = value);
                }
              },
            ),
            const SizedBox(height: 16),

            // Weekday Selection
            if (_repetitionType == RepetitionType.weekdays.name) ...[
              const Text('Select Days', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children:
                    ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'].map((day) {
                      return FilterChip(
                        selected: _selectedWeekdays.contains(day),
                        label: Text(day),
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedWeekdays.add(day);
                            } else {
                              _selectedWeekdays.remove(day);
                            }
                          });
                        },
                      );
                    }).toList(),
              ),
            ],

            // Custom Dates Selection
            if (_repetitionType == RepetitionType.customDates.name) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Select Dates', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  TextButton.icon(
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (date != null && !_customDates.contains(date)) {
                        setState(() => _customDates.add(date));
                      }
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add Date'),
                  ),
                ],
              ),
              Wrap(
                spacing: 8,
                children:
                    _customDates.map((date) {
                      return Chip(
                        label: Text(DateFormat('MMM d').format(date)),
                        onDeleted: () {
                          setState(() => _customDates.remove(date));
                        },
                      );
                    }).toList(),
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: _updateSettings,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppPallete.gradient1,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Save Settings'),
          ),
        ),
      ),
    );
  }
}
