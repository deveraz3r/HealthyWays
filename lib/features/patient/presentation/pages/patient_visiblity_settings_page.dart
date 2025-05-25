import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthyways/core/common/controllers/app_profile_controller.dart';
import 'package:healthyways/core/common/entites/patient_profile.dart';
import 'package:healthyways/core/theme/app_pallete.dart';

class PatientVisibilitySettingsPage extends StatelessWidget {
  static route() =>
      MaterialPageRoute(builder: (_) => const PatientVisibilitySettingsPage());
  const PatientVisibilitySettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AppProfileController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Privacy Settings"),
        backgroundColor: AppPallete.backgroundColor2,
      ),
      body: Obx(() {
        final profile = controller.profile.data as PatientProfile;
        if (profile == null) {
          return const Center(child: Text('No profile loaded.'));
        }

        final visibilityOptions = [
          {
            'label': 'Global Visibility',
            'value': profile.globalVisibility.type.name,
          },
          {
            'label': 'Allergies Visibility',
            'value': profile.allergiesVisibility.type.name,
          },
          {
            'label': 'Immunizations Visibility',
            'value': profile.immunizationsVisibility.type.name,
          },
          {
            'label': 'Lab Reports Visibility',
            'value': profile.labReportsVisibility.type.name,
          },
          {
            'label': 'Diaries Visibility',
            'value': profile.diariesVisibility.type.name,
          },
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
              trailing: const Icon(Icons.edit),
              onTap: () {
                // TODO: Implement update logic or modal
                print('${option['label']} tapped');
              },
            );
          },
        );
      }),
    );
  }
}
