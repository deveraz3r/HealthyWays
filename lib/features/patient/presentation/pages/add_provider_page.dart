import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthyways/core/theme/app_pallete.dart';
import 'package:healthyways/features/doctor/presentation/controllers/doctor_controller.dart';
import 'package:healthyways/features/patient/presentation/controllers/patient_controller.dart';
import 'package:healthyways/features/pharmacist/presentation/controllers/pharmacist_controller.dart';

class AddProviderPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (_) => const AddProviderPage());

  const AddProviderPage({super.key});

  @override
  State<AddProviderPage> createState() => _AddProviderPageState();
}

class _AddProviderPageState extends State<AddProviderPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final DoctorController _doctorController = Get.find();
  final PharmacistController _pharmacistController = Get.find();
  final PatientController _patientController = Get.find();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _doctorController.getAllDoctors();
    _pharmacistController.fetchAllPharmacists();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Provider'),
        backgroundColor: AppPallete.backgroundColor2,
        bottom: TabBar(controller: _tabController, tabs: const [Tab(text: 'Doctors'), Tab(text: 'Pharmacists')]),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: 'Search providers...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          Expanded(
            child: TabBarView(controller: _tabController, children: [_buildDoctorsList(), _buildPharmacistsList()]),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorsList() {
    return Obx(() {
      if (_doctorController.allDoctors.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      if (_doctorController.allDoctors.hasError) {
        return Center(child: Text('Error: ${_doctorController.allDoctors.error?.message}'));
      }

      final doctors =
          _doctorController.allDoctors.data!.where((doctor) {
            final searchLower = _searchQuery.toLowerCase();
            return doctor.fName.toLowerCase().contains(searchLower) ||
                doctor.lName.toLowerCase().contains(searchLower) ||
                doctor.specality.toLowerCase().contains(searchLower);
          }).toList();

      if (doctors.isEmpty) {
        return const Center(child: Text('No doctors found'));
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: doctors.length,
        itemBuilder: (context, index) {
          final doctor = doctors[index];
          return Card(
            child: ListTile(
              title: Text('Dr. ${doctor.fName} ${doctor.lName}'),
              subtitle: Text(doctor.specality),
              trailing: IconButton(
                icon: const Icon(Icons.add_circle_outline),
                color: AppPallete.gradient1,
                onPressed: () {
                  _patientController.addMyProvider(doctor.uid);
                },
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildPharmacistsList() {
    return Obx(() {
      if (_pharmacistController.allPharmacists.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      if (_pharmacistController.allPharmacists.hasError) {
        return Center(child: Text('Error: ${_pharmacistController.allPharmacists.error?.message}'));
      }

      final pharmacists =
          _pharmacistController.allPharmacists.data!.where((pharmacist) {
            final searchLower = _searchQuery.toLowerCase();
            return pharmacist.fName.toLowerCase().contains(searchLower) ||
                pharmacist.lName.toLowerCase().contains(searchLower);
          }).toList();

      if (pharmacists.isEmpty) {
        return const Center(child: Text('No pharmacists found'));
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: pharmacists.length,
        itemBuilder: (context, index) {
          final pharmacist = pharmacists[index];
          return Card(
            child: ListTile(
              title: Text('${pharmacist.fName} ${pharmacist.lName}'),
              subtitle: const Text('Pharmacist'),
              trailing: IconButton(
                icon: const Icon(Icons.add_circle_outline),
                color: AppPallete.gradient1,
                onPressed: () {
                  _patientController.addMyProvider(pharmacist.uid);
                },
              ),
            ),
          );
        },
      );
    });
  }
}
