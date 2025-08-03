import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthyways/core/theme/app_pallete.dart';
import 'package:healthyways/features/doctor/presentation/controllers/doctor_controller.dart';
import 'package:healthyways/features/patient/presentation/controllers/patient_controller.dart';

class AddPatientPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (_) => const AddPatientPage());

  const AddPatientPage({super.key});

  @override
  State<AddPatientPage> createState() => _AddPatientPageState();
}

class _AddPatientPageState extends State<AddPatientPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final DoctorController _doctorController = Get.find();
  final PatientController _patientController = Get.find();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Optionally fetch all patients
    _patientController.getAllPatients();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onAddPatient(String patientId) async {
    await _doctorController.addMyPatient(patientId);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Patient added successfully!')),
    );
    // Optionally pop or refresh
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Patient'),
        backgroundColor: AppPallete.backgroundColor2,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: 'All Patients'), Tab(text: 'My Patients')],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildAllPatientsTab(), _buildMyPatientsTab()],
      ),
    );
  }

  Widget _buildAllPatientsTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              labelText: 'Search Patients',
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
        ),
        Expanded(
          child: Obx(() {
            final patients = _patientController.allPatients.data ?? [];
            final filtered =
                patients
                    .where(
                      (p) =>
                          p.fName.toLowerCase().contains(
                            _searchQuery.toLowerCase(),
                          ) ||
                          p.lName.toLowerCase().contains(
                            _searchQuery.toLowerCase(),
                          ),
                    )
                    .toList();
            if (_patientController.allPatients.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (filtered.isEmpty) {
              return const Center(child: Text('No patients found.'));
            }
            return ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final patient = filtered[index];
                return ListTile(
                  title: Text('${patient.fName} ${patient.lName}'),
                  subtitle: Text(patient.email),
                  trailing: ElevatedButton(
                    onPressed: () => _onAddPatient(patient.uid),
                    child: const Text('Add'),
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildMyPatientsTab() {
    return Center(child: Text('My Patients List (implement as needed)'));
  }
}
