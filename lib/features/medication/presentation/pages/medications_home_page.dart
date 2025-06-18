import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthyways/core/theme/app_pallete.dart';
import 'package:healthyways/features/medication/presentation/controllers/medication_controller.dart';
import 'package:healthyways/features/patient/presentation/widgets/medication_card.dart';
import 'package:healthyways/init_dependences.dart';
import 'package:intl/intl.dart';

class MedicationsHomePage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => MedicationsHomePage());
  const MedicationsHomePage({super.key});

  @override
  State<MedicationsHomePage> createState() => _MedicationsHomePageState();
}

class _MedicationsHomePageState extends State<MedicationsHomePage> {
  final MedicationController medicationController = Get.put(serviceLocator<MedicationController>());

  // Add selected date state
  DateTime selectedDate = DateTime.now();

  // Add method to change date
  void _changeDate(int days) {
    setState(() {
      selectedDate = selectedDate.add(Duration(days: days));
    });
  }

  // Add these helper methods
  Map<String, List<dynamic>> _categorizedMedications(List<dynamic> medications) {
    return {
      'Morning':
          medications.where((med) {
            final hour = med.allocatedTime.hour;
            return hour >= 5 && hour < 12;
          }).toList(),
      'Afternoon':
          medications.where((med) {
            final hour = med.allocatedTime.hour;
            return hour >= 12 && hour < 17;
          }).toList(),
      'Evening':
          medications.where((med) {
            final hour = med.allocatedTime.hour;
            return hour >= 17 && hour < 21;
          }).toList(),
      'Night':
          medications.where((med) {
            final hour = med.allocatedTime.hour;
            return hour >= 21 || hour < 5;
          }).toList(),
    };
  }

  Widget _buildTimeSection(String title, List<dynamic> medications) {
    if (medications.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(
                title == 'Morning'
                    ? Icons.wb_sunny
                    : title == 'Afternoon'
                    ? Icons.wb_cloudy
                    : title == 'Evening'
                    ? Icons.wb_twilight
                    : Icons.nightlight_round,
                color: AppPallete.greyColor,
              ),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        SizedBox(
          height: 150, // Adjust height based on your card size
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: medications.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: SizedBox(
                  width: 200, // Fixed width for each card
                  // child: MedicationCard(medication: medications[index]),
                ),
              );
            },
          ),
        ),
      ],
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
    // Update to use selectedDate instead of today
    final filteredMeds =
        medicationController.allMedications.data
            ?.where(
              (e) =>
                  e.allocatedTime.year == selectedDate.year &&
                  e.allocatedTime.month == selectedDate.month &&
                  e.allocatedTime.day == selectedDate.day,
            )
            .toList() ??
        [];

    final categorizedMeds = _categorizedMedications(filteredMeds);

    return Scaffold(
      body: Column(
        children: [
          // Update the date container to be long-pressable
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
                // color: AppPallete.backgroundColor.withAlpha(
                //   (0.2 * 255).round(),
                // ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppPallete.gradient1.withOpacity(0.3), width: 1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Previous day button
                  IconButton(onPressed: () => _changeDate(-1), icon: const Icon(Icons.chevron_left, size: 30)),
                  // Date display
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
                  // Next day button
                  IconButton(onPressed: () => _changeDate(1), icon: const Icon(Icons.chevron_right, size: 30)),
                ],
              ),
            ),
          ),

          // Medication sections
          Expanded(
            child:
                filteredMeds.isEmpty
                    ? const Center(child: Text('No medications for today.'))
                    : ListView(
                      children: [
                        _buildTimeSection('Morning', categorizedMeds['Morning']!),
                        _buildTimeSection('Afternoon', categorizedMeds['Afternoon']!),
                        _buildTimeSection('Evening', categorizedMeds['Evening']!),
                        _buildTimeSection('Night', categorizedMeds['Night']!),
                      ],
                    ),
          ),
        ],
      ),
    );
  }
}
