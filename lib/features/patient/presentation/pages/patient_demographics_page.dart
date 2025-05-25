import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthyways/core/common/controllers/app_patient_controller.dart';
import 'package:healthyways/core/common/entites/patient_profile.dart';
import 'package:healthyways/core/theme/app_pallete.dart';

class PatientDemographicsPage extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const PatientDemographicsPage());

  const PatientDemographicsPage({super.key});

  @override
  State<PatientDemographicsPage> createState() =>
      _PatientDemographicsPageState();
}

class _PatientDemographicsPageState extends State<PatientDemographicsPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;
  late TextEditingController _raceController;
  late String _gender;
  late String _languageCode;
  late bool _isMarried;

  final Map<String, String> languageMap = {
    'en': 'English',
    'es': 'Spanish',
    'fr': 'French',
    'de': 'German',
    'other': 'Other',
  };

  @override
  void initState() {
    super.initState();
    final patient = Get.find<AppPatientController>().patient.data!;
    _firstNameController = TextEditingController(text: patient.fName);
    _lastNameController = TextEditingController(text: patient.lName);
    _emailController = TextEditingController(text: patient.email);
    _addressController = TextEditingController(text: patient.address ?? '');
    _raceController = TextEditingController(text: patient.race ?? '');
    _gender = patient.gender;
    _languageCode =
        languageMap.containsKey(patient.preferedLanguage)
            ? patient.preferedLanguage
            : 'en';
    _isMarried = patient.isMarried;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _raceController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      final patientController = Get.find<AppPatientController>();
      final currentPatient = patientController.patient.data!;

      final updatedPatient = PatientProfile(
        uid: currentPatient.uid,
        email: _emailController.text,
        fName: _firstNameController.text,
        lName: _lastNameController.text,
        gender: _gender,
        preferedLanguage: _languageCode,
        selectedRole: currentPatient.selectedRole,
        myMeasurements: currentPatient.myMeasurements,
        race: _raceController.text,
        isMarried: _isMarried,
        emergencyContacts: currentPatient.emergencyContacts,
        insuranceIds: currentPatient.insuranceIds,
        globalVisibility: currentPatient.globalVisibility,
        allergiesVisibility: currentPatient.allergiesVisibility,
        immunizationsVisibility: currentPatient.immunizationsVisibility,
        labReportsVisibility: currentPatient.labReportsVisibility,
        diariesVisibility: currentPatient.diariesVisibility,
        address: _addressController.text,
        createdAt: currentPatient.createdAt,
      );

      patientController.updatePatient(updatedPatient);
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demographics'),
        backgroundColor: AppPallete.backgroundColor2,
        actions: [
          TextButton(
            onPressed: _saveChanges,
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _firstNameController,
              decoration: const InputDecoration(
                labelText: 'First Name',
                border: OutlineInputBorder(),
              ),
              validator:
                  (value) =>
                      value == null || value.isEmpty
                          ? 'Enter first name'
                          : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _lastNameController,
              decoration: const InputDecoration(
                labelText: 'Last Name',
                border: OutlineInputBorder(),
              ),
              validator:
                  (value) =>
                      value == null || value.isEmpty ? 'Enter last name' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter email';
                } else if (!value.contains('@')) {
                  return 'Invalid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: 'Address',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _gender,
              decoration: const InputDecoration(
                labelText: 'Gender',
                border: OutlineInputBorder(),
              ),
              items:
                  ['Male', 'Female', 'Other']
                      .map(
                        (gender) => DropdownMenuItem(
                          value: gender,
                          child: Text(gender),
                        ),
                      )
                      .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _gender = value);
                }
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: languageMap[_languageCode],
              decoration: const InputDecoration(
                labelText: 'Preferred Language',
                border: OutlineInputBorder(),
              ),
              items:
                  languageMap.values
                      .map(
                        (label) =>
                            DropdownMenuItem(value: label, child: Text(label)),
                      )
                      .toList(),
              onChanged: (label) {
                final code =
                    languageMap.entries.firstWhere((e) => e.value == label).key;
                setState(() => _languageCode = code);
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _raceController,
              decoration: const InputDecoration(
                labelText: 'Race/Ethnicity',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Marital Status'),
              subtitle: Text(_isMarried ? 'Married' : 'Single'),
              value: _isMarried,
              onChanged: (value) => setState(() => _isMarried = value),
            ),
          ],
        ),
      ),
    );
  }
}
