import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthyways/core/common/controllers/app_profile_controller.dart';
import 'package:healthyways/core/common/custom_types/visibility.dart' as custom_visibility;
import 'package:healthyways/core/common/custom_types/visibility_type.dart';
import 'package:healthyways/core/common/entites/patient_profile.dart';
import 'package:healthyways/core/common/models/patient_profile_model.dart';
import 'package:healthyways/core/theme/app_pallete.dart';
import 'package:healthyways/features/measurements/domain/entites/preset_measurement.dart';
import 'package:healthyways/features/measurements/presentation/controllers/measurement_controller.dart';

class VisibilityDetailsPage extends StatefulWidget {
  static route(PresetMeasurement measurement) =>
      MaterialPageRoute(builder: (context) => VisibilityDetailsPage(measurement: measurement));

  final PresetMeasurement measurement;

  const VisibilityDetailsPage({super.key, required this.measurement});

  @override
  State<VisibilityDetailsPage> createState() => _VisibilityDetailsPageState();
}

class _VisibilityDetailsPageState extends State<VisibilityDetailsPage> {
  final _profileController = Get.find<AppProfileController>();
  final _measurementController = Get.find<MeasurementController>();

  late VisibilityType _selectedType;
  final _customAccessList = <String>[].obs;

  @override
  void initState() {
    super.initState();
    final patientProfile = _profileController.profile.data as PatientProfile;
    final myMeasurement = patientProfile.myMeasurements.firstWhere(
      (m) => m.id == widget.measurement.id,
      orElse: () => throw Exception('Measurement not found in profile'),
    );

    _selectedType = myMeasurement.visiblity.type;
    _customAccessList.addAll(myMeasurement.visiblity.customAccess);
  }

  void _updateVisibility({VisibilityType? newType, List<String>? newCustomList}) {
    final patientProfile = _profileController.profile.data as PatientProfileModel;

    final newVisibility = custom_visibility.Visibility(
      type: newType ?? _selectedType,
      customAccess:
          (newType ?? _selectedType) == VisibilityType.custom ? (newCustomList ?? _customAccessList.toList()) : [],
    );

    // Update local profile state
    final updatedMeasurements =
        patientProfile.myMeasurements.map((m) {
          if (m.id == widget.measurement.id) {
            return m.copyWith(visiblity: newVisibility);
          }
          return m;
        }).toList();

    final updatedProfile = patientProfile.copyWith(myMeasurements: updatedMeasurements);
    _profileController.updateProfile(updatedProfile);

    // Sync to Supabase
    _measurementController.measurementVisibility.setData(newVisibility);
    _measurementController.updateMeasurementVisibility(measurementId: widget.measurement.id);
  }

  void _showAddEmailDialog() {
    final TextEditingController emailController = TextEditingController();
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
                    _customAccessList.add(email);
                    _updateVisibility(newCustomList: _customAccessList.toList());
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
    _customAccessList.remove(email);
    _updateVisibility(newCustomList: _customAccessList.toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Visibility Settings'), backgroundColor: AppPallete.backgroundColor2),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Who can see this measurement?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            DropdownButtonFormField<VisibilityType>(
              value: _selectedType,
              items:
                  VisibilityType.values
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
              const SizedBox(height: 12),
              const Divider(),
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
                                color: Colors.black.withOpacity(0.05),
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
      case VisibilityType.all:
        return 'All Healthcare Providers';
      case VisibilityType.doctors:
        return 'Doctors Only';
      case VisibilityType.pharmacist:
        return 'Pharmacists Only';
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
        return 'Measurement is controlled by global app settings';
      case VisibilityType.all:
        return 'All healthcare providers can see this measurement';
      case VisibilityType.doctors:
        return 'Only doctors can see this measurement';
      case VisibilityType.pharmacist:
        return 'Only pharmacists can see this measurement';
      case VisibilityType.custom:
        return 'Only specific people can see this measurement';
      case VisibilityType.private:
        return 'Only you can see this measurement';
      case VisibilityType.disabled:
        return 'Only you can see this measurement';
    }
  }
}
