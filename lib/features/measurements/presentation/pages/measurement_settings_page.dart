import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthyways/core/theme/app_pallete.dart';
import 'package:healthyways/features/measurements/domain/entites/preset_measurement.dart';
import 'package:healthyways/features/measurements/presentation/controllers/measurement_controller.dart';
import 'package:healthyways/features/measurements/presentation/pages/my_measurement_reminder_settings_page.dart';
import 'package:healthyways/features/measurements/presentation/pages/visibility_details_page.dart';

class MeasurementSettingsPage extends StatelessWidget {
  static route({required PresetMeasurement measurement}) =>
      MaterialPageRoute(builder: (_) => MeasurementSettingsPage(measurement: measurement));

  const MeasurementSettingsPage({super.key, required this.measurement});
  final PresetMeasurement measurement;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MeasurementController>();

    final List<Map<String, dynamic>> settingsOptions = [
      {
        'title': 'Reminder Settings',
        'subtitle': 'Set up measurement reminders',
        'icon': Icons.notifications_active,
        'onTap': () => Navigator.push(context, MyMeasurementReminderSettingsPage.route(measurement)),
      },
      {
        'title': 'Visibility Settings',
        'subtitle': 'Control who can see your measurements',
        'icon': Icons.visibility,
        'onTap': () => Navigator.push(context, VisibilityDetailsPage.route(measurement)),
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Measurement Settings'), backgroundColor: AppPallete.backgroundColor2),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: settingsOptions.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          final option = settingsOptions[index];
          return ListTile(
            leading: Icon(option['icon'] as IconData, color: AppPallete.gradient1),
            title: Text(option['title'] as String, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            subtitle: Text(option['subtitle'] as String, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
            trailing: const Icon(Icons.chevron_right, color: AppPallete.gradient1),
            onTap: option['onTap'] as VoidCallback,
          );
        },
      ),
    );
  }
}
