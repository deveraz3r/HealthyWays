import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthyways/core/common/entites/patient_profile.dart';
import 'package:healthyways/core/theme/app_pallete.dart';
import 'package:healthyways/core/common/controllers/app_profile_controller.dart';
import 'package:healthyways/features/patient/presentation/controllers/patient_controller.dart';
import 'package:healthyways/features/patient/presentation/pages/patient_details_page.dart';
import 'package:healthyways/features/patient/presentation/widgets/patient_card.dart';

class MyPatientsPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (_) => const MyPatientsPage());

  const MyPatientsPage({super.key});

  @override
  State<MyPatientsPage> createState() => _MyPatientsPageState();
}

class _MyPatientsPageState extends State<MyPatientsPage> {
  final PatientController _patientController = Get.find();
  final AppProfileController _appProfileController = Get.find();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _patientController.getAllPatients();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUserUid = _appProfileController.profile.data!.uid;

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('My Patients'),
      //   backgroundColor: AppPallete.backgroundColor2,
      // ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: 'Search my patients...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (_patientController.allPatients.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (_patientController.allPatients.hasError) {
                return Center(
                  child: Text(
                    'Error: ${_patientController.allPatients.error?.message ?? "Unknown error"}',
                  ),
                );
              }

              final List<PatientProfile> allPatients =
                  _patientController.allPatients.data ?? [];

              final List<PatientProfile> myPatients =
                  allPatients.where((patient) {
                    return patient.myProviders.contains(currentUserUid);
                  }).toList();

              final filteredPatients =
                  myPatients.where((patient) {
                    final query = _searchQuery.toLowerCase();
                    return patient.fName.toLowerCase().contains(query) ||
                        patient.lName.toLowerCase().contains(query) ||
                        (patient.address?.toLowerCase().contains(query) ??
                            false);
                  }).toList();

              if (filteredPatients.isEmpty) {
                return const Center(child: Text('No patients found.'));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: filteredPatients.length,
                itemBuilder: (context, index) {
                  final patient = filteredPatients[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: PatientCard(
                      patient: patient,
                      onTap: () {
                        Navigator.push(
                          context,
                          PatientDetailsPage.route(patient),
                        );
                      },
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
