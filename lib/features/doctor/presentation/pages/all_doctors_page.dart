import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthyways/core/theme/app_pallete.dart';
import 'package:healthyways/features/doctor/presentation/controllers/doctor_controller.dart';
import 'package:healthyways/features/doctor/presentation/pages/doctor_details_page.dart';
import 'package:healthyways/features/doctor/presentation/widgets/doctor_card.dart';

class AllDoctorsPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (_) => const AllDoctorsPage());

  const AllDoctorsPage({super.key});

  @override
  State<AllDoctorsPage> createState() => _AllDoctorsPageState();
}

class _AllDoctorsPageState extends State<AllDoctorsPage> {
  final DoctorController _doctorController = Get.find();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _doctorController.getAllDoctors();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Find Doctors'), backgroundColor: AppPallete.backgroundColor2),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: 'Search doctors...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          // Doctors List
          Expanded(
            child: Obx(() {
              if (_doctorController.allDoctors.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (_doctorController.allDoctors.hasError) {
                return Center(child: Text('Error: ${_doctorController.allDoctors.error?.message}'));
              }

              final doctors =
                  _doctorController.allDoctors.data!.where((doctor) {
                    return doctor.fName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                        doctor.lName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                        (doctor.address?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);
                  }).toList();

              if (doctors.isEmpty) {
                return const Center(child: Text('No doctors found'));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: doctors.length,
                itemBuilder: (context, index) {
                  final doctor = doctors[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: DoctorCard(
                      doctor: doctor,
                      onTap: () {
                        // Navigate to doctor details page
                        Navigator.push(context, DoctorDetailsPage.route(doctor.uid));
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
