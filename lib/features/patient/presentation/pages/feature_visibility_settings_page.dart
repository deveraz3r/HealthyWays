import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthyways/core/common/custom_types/visibility.dart' as custom_visibility;
import 'package:healthyways/core/common/custom_types/visibility_type.dart';
import 'package:healthyways/core/common/entites/patient_profile.dart';
import 'package:healthyways/core/theme/app_pallete.dart';
import 'package:healthyways/features/patient/presentation/controllers/patient_controller.dart';

class FeatureVisibilitySettingsPage extends StatefulWidget {
  static route({required String feature, required String title}) =>
      MaterialPageRoute(builder: (_) => FeatureVisibilitySettingsPage(feature: feature, title: title));

  final String feature;
  final String title;

  const FeatureVisibilitySettingsPage({super.key, required this.feature, required this.title});

  @override
  State<FeatureVisibilitySettingsPage> createState() => _FeatureVisibilitySettingsPageState();
}

class _FeatureVisibilitySettingsPageState extends State<FeatureVisibilitySettingsPage> {
  final _patientController = Get.find<PatientController>();

  late VisibilityType _selectedType;
  final _customAccessList = <String>[].obs;

  @override
  void initState() {
    super.initState();

    // Get current visibility settings based on feature
    final visibility = _getFeatureVisibility(_patientController.patient.data!);
    _selectedType = visibility.type;
    // Convert the List<String> to RxList<String>
    _customAccessList.value = visibility.customAccess.toList(); // Changed from assignAll
  }

  custom_visibility.Visibility _getFeatureVisibility(PatientProfile profile) {
    switch (widget.feature) {
      case 'global':
        return profile.globalVisibility;
      case 'allergies':
        return profile.allergiesVisibility;
      case 'immunizations':
        return profile.immunizationsVisibility;
      case 'labReports':
        return profile.labReportsVisibility;
      case 'diaries':
        return profile.diariesVisibility;
      case 'measurements':
        return profile.measurementsVisibility;
      default:
        return custom_visibility.Visibility(type: VisibilityType.private, customAccess: []);
    }
  }

  void _updateVisibility({VisibilityType? newType, List<String>? newCustomList}) {
    final newVisibility = custom_visibility.Visibility(
      type: newType ?? _selectedType,
      customAccess:
          (newType ?? _selectedType) == VisibilityType.custom ? (newCustomList ?? _customAccessList.toList()) : [],
    );

    _patientController.updateVisibilitySettings(featureId: widget.feature, visibility: newVisibility);
  }

  void _showAddEmailDialog() {
    final emailController = TextEditingController();
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Add Email Access'),
            content: TextField(
              controller: emailController,
              decoration: const InputDecoration(hintText: 'Enter email address'),
              keyboardType: TextInputType.emailAddress,
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
              ElevatedButton(
                onPressed: () {
                  final email = emailController.text.trim();
                  if (email.isNotEmpty && email.contains('@')) {
                    final newList = [..._customAccessList, email];
                    _customAccessList.value = newList; // Changed from add
                    _updateVisibility(newCustomList: newList);
                    Navigator.pop(ctx);
                  }
                },
                child: const Text('Add'),
              ),
            ],
          ),
    );
  }

  void _removeCustomAccess(String email) {
    final newList = _customAccessList.where((e) => e != email).toList();
    _customAccessList.value = newList; // Changed from remove
    _updateVisibility(newCustomList: newList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title), backgroundColor: AppPallete.backgroundColor2),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Who can see this information?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            DropdownButtonFormField<VisibilityType>(
              value: _selectedType,
              items:
                  VisibilityType.values
                      .where((type) {
                        if (type == VisibilityType.disabled) {
                          return widget.feature == 'global' || widget.feature == 'measurements';
                        }
                        return true;
                      })
                      .map((type) => DropdownMenuItem(value: type, child: Text(_getVisibilityTypeTitle(type))))
                      .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedType = value);
                  _updateVisibility(newType: value);
                }
              },
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 8),
            Text(
              _getVisibilityTypeDescription(_selectedType),
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            if (_selectedType == VisibilityType.custom) ...[
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Custom Access List', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  IconButton(onPressed: _showAddEmailDialog, icon: const Icon(Icons.add_circle_outline)),
                ],
              ),
              const SizedBox(height: 12),
              Obx(() {
                if (_customAccessList.isEmpty) {
                  return const Text('Add people with private access', style: TextStyle(color: Colors.grey));
                }
                return Column(
                  children:
                      _customAccessList.map((email) {
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: AppPallete.backgroundColor2,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(13), // Approximation for 5% opacity
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                            border: Border.all(color: Colors.black12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.email_outlined, color: Colors.grey),
                              const SizedBox(width: 10),
                              Expanded(child: Text(email, style: const TextStyle(fontSize: 15))),
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline, color: Colors.redAccent),
                                onPressed: () => _removeCustomAccess(email),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                );
              }),
            ],
          ],
        ),
      ),
    );
  }

  String _getVisibilityTypeTitle(VisibilityType type) {
    switch (type) {
      case VisibilityType.global:
        return 'Global';
      case VisibilityType.myProviders:
        return 'My Healthcare Providers';
      case VisibilityType.custom:
        return 'Custom';
      case VisibilityType.private:
        return 'Only Me';
      case VisibilityType.disabled:
        return 'Disabled';
    }
  }

  String _getVisibilityTypeDescription(VisibilityType type) {
    switch (type) {
      case VisibilityType.global:
        return 'Use global visibility settings';
      case VisibilityType.myProviders:
        return 'Only healthcare providers you have connected with can see this information';
      case VisibilityType.custom:
        return 'Only specific people can see this information';
      case VisibilityType.private:
        return 'Only you can see this information';
      case VisibilityType.disabled: //only visible in global and measurements visiblity settings
        return 'Visiblity will be controlled by feature specfic settings';
    }
  }
}
