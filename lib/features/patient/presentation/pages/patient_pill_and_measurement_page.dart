import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthyways/core/theme/app_pallete.dart';
import 'package:healthyways/features/patient/presentation/widgets/medication_card.dart';
import 'package:healthyways/features/patient/presentation/controllers/patient_controller.dart';
import 'package:intl/intl.dart';
import 'package:healthyways/core/common/custom_types/my_measurements.dart';
import 'package:healthyways/core/common/custom_types/repetition_type.dart';
import 'package:healthyways/core/common/entites/patient_profile.dart';
import 'package:healthyways/features/patient/presentation/widgets/patient_measurement_card.dart';

class _ScheduleItem {
  final DateTime time;
  final dynamic item;
  final bool isMedication;

  _ScheduleItem({required this.time, required this.item, required this.isMedication});
}

class PatientPillAndMeasurementPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const PatientPillAndMeasurementPage());

  const PatientPillAndMeasurementPage({super.key});

  @override
  State<PatientPillAndMeasurementPage> createState() => _PatientPillAndMeasurementPageState();
}

class _PatientPillAndMeasurementPageState extends State<PatientPillAndMeasurementPage> {
  final PatientController patientController = Get.find();
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    patientController.getAllMedications();
  }

  void _changeDate(int days) {
    setState(() {
      selectedDate = selectedDate.add(Duration(days: days));
    });
  }

  List<MyMeasurements> _getValidMeasurements() {
    final profile = patientController.patient.data as PatientProfile;
    final measurements = profile.myMeasurements.where((m) => m.isActive).toList();

    return measurements.where((m) {
      switch (m.repetitionType) {
        case RepetitionType.none:
          return false;
        case RepetitionType.daily:
          return true;
        case RepetitionType.weekdays:
          final weekday = DateFormat('E').format(selectedDate).substring(0, 3);
          return m.weekdays?.contains(weekday) ?? false;
        case RepetitionType.customDates:
          return m.customDates?.any(
                (date) =>
                    date.year == selectedDate.year && date.month == selectedDate.month && date.day == selectedDate.day,
              ) ??
              false;
      }
    }).toList();
  }

  List<_ScheduleItem> _getScheduledItems() {
    final List<_ScheduleItem> items = [];

    // Add medications
    final filteredMeds =
        patientController.patientMedications.data
            ?.where(
              (e) =>
                  e.allocatedTime.year == selectedDate.year &&
                  e.allocatedTime.month == selectedDate.month &&
                  e.allocatedTime.day == selectedDate.day,
            )
            .map((med) => _ScheduleItem(time: med.allocatedTime, item: med, isMedication: true))
            .toList() ??
        [];
    items.addAll(filteredMeds);

    // Add measurements
    final measurements = _getValidMeasurements();
    for (final measurement in measurements) {
      final dateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        measurement.time.hour,
        measurement.time.minute,
      );
      items.add(_ScheduleItem(time: dateTime, item: measurement, isMedication: false));
    }

    // Sort by time
    items.sort((a, b) => a.time.compareTo(b.time));
    return items;
  }

  Widget _buildScheduleList(List<_ScheduleItem> items) {
    if (items.isEmpty) {
      return const Center(
        child: Padding(padding: EdgeInsets.all(16.0), child: Text('No medications or measurements for today.')),
      );
    }

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child:
              item.isMedication
                  ? MedicationCard(medication: item.item)
                  : PatientMeasurementCard(measurement: item.item, time: DateFormat('hh:mm a').format(item.time)),
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppPallete.gradient1,
              onPrimary: Colors.white,
              surface: AppPallete.backgroundColor,
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: AppPallete.backgroundColor2,
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (patientController.patientMedications.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (patientController.patientMedications.hasError) {
          return Center(child: Text('Error: ${patientController.patientMedications.error?.message}'));
        }

        final scheduleItems = _getScheduledItems();

        return Column(
          children: [
            GestureDetector(
              onLongPress: () => _selectDate(context),
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.all(16.0),
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppPallete.gradient1.withOpacity(0.2), AppPallete.backgroundColor2],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppPallete.gradient1.withOpacity(0.3), width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(onPressed: () => _changeDate(-1), icon: const Icon(Icons.chevron_left, size: 30)),
                    Column(
                      children: [
                        Text(
                          DateFormat('EEEE').format(selectedDate),
                          style: const TextStyle(fontSize: 16, color: AppPallete.greyColor),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('d').format(selectedDate),
                          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          DateFormat('MMMM yyyy').format(selectedDate),
                          style: const TextStyle(fontSize: 16, color: AppPallete.greyColor),
                        ),
                      ],
                    ),
                    IconButton(onPressed: () => _changeDate(1), icon: const Icon(Icons.chevron_right, size: 30)),
                  ],
                ),
              ),
            ),
            Expanded(child: _buildScheduleList(scheduleItems)),
          ],
        );
      }),
    );
  }
}
