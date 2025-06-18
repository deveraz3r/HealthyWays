import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthyways/core/common/controllers/app_profile_controller.dart';
import 'package:healthyways/core/common/entites/patient_profile.dart';
import 'package:healthyways/core/theme/app_pallete.dart';
import 'package:healthyways/features/patient/presentation/pages/feature_visibility_settings_page.dart';

class PatientVisibilitySettingsPage extends StatelessWidget {
  static route() => MaterialPageRoute(builder: (_) => const PatientVisibilitySettingsPage());
  const PatientVisibilitySettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AppProfileController>();

    return Scaffold(
      appBar: AppBar(title: const Text("Privacy Settings"), backgroundColor: AppPallete.backgroundColor2),
      body: Obx(() {
        final profile = controller.profile.data as PatientProfile;
        if (profile == null) {
          return const Center(child: Text('No profile loaded.'));
        }

        final visibilityOptions = [
          {'id': 'global', 'label': 'Global Visibility', 'value': profile.globalVisibility.type.name},
          {'id': 'allergies', 'label': 'Allergies Visibility', 'value': profile.allergiesVisibility.type.name},
          {
            'id': 'immunizations',
            'label': 'Immunizations Visibility',
            'value': profile.immunizationsVisibility.type.name,
          },
          {'id': 'labReports', 'label': 'Lab Reports Visibility', 'value': profile.labReportsVisibility.type.name},
          {'id': 'diaries', 'label': 'Diaries Visibility', 'value': profile.diariesVisibility.type.name},
          {'id': 'measurements', 'label': 'Measurements Visibility', 'value': profile.measurementsVisibility.type.name},
        ];

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: visibilityOptions.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (_, index) {
            final option = visibilityOptions[index];
            return ListTile(
              title: Text(option['label'].toString()),
              subtitle: Text(option['value'].toString()),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  FeatureVisibilitySettingsPage.route(
                    feature: option['id'].toString(),
                    title: option['label'].toString(),
                  ),
                );
              },
            );
          },
        );
      }),
    );
  }
}
