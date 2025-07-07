import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthyways/core/theme/app_pallete.dart';
import 'package:healthyways/features/doctor/presentation/controllers/doctor_controller.dart';
import 'package:healthyways/features/pharmacist/presentation/controllers/pharmacist_controller.dart';

class ProviderCard extends StatefulWidget {
  final String providerId;
  final VoidCallback onRemove;

  const ProviderCard({super.key, required this.providerId, required this.onRemove});

  @override
  State<ProviderCard> createState() => _ProviderCardState();
}

class _ProviderCardState extends State<ProviderCard> {
  final DoctorController _doctorController = Get.find();
  final PharmacistController _pharmacistController = Get.find();

  @override
  void initState() {
    super.initState();
    _loadProviderDetails();
  }

  Future<void> _loadProviderDetails() async {
    // Try to find in doctors first
    await _doctorController.getDoctorById(widget.providerId);

    // If doctor not found, try pharmacists
    if (_doctorController.doctor.hasError || _doctorController.doctor.data == null) {
      await _pharmacistController.fetchPharmacistById(widget.providerId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Check doctor controller state
      if (_doctorController.doctor.isLoading) {
        return const Card(
          child: Padding(padding: EdgeInsets.all(16), child: Center(child: CircularProgressIndicator())),
        );
      }

      // If doctor found
      if (_doctorController.doctor.hasData) {
        final doctor = _doctorController.doctor.data!;
        return _buildProviderCard(
          name: 'Dr. ${doctor.fName} ${doctor.lName}',
          role: 'Doctor',
          speciality: doctor.specality,
        );
      }

      // Check pharmacist controller state
      if (_pharmacistController.selectedPharmacist.isLoading) {
        return const Card(
          child: Padding(padding: EdgeInsets.all(16), child: Center(child: CircularProgressIndicator())),
        );
      }

      // If pharmacist found
      if (_pharmacistController.selectedPharmacist.hasData) {
        final pharmacist = _pharmacistController.selectedPharmacist.data!;
        return _buildProviderCard(name: '${pharmacist.fName} ${pharmacist.lName}', role: 'Pharmacist');
      }

      // If both controllers have errors or no data found
      if (_doctorController.doctor.hasError || _pharmacistController.selectedPharmacist.hasError) {
        return _buildProviderCard(name: 'Error loading provider', role: 'Unknown');
      }

      // Default fallback
      return _buildProviderCard(name: 'Unknown Provider', role: 'Unknown');
    });
  }

  Widget _buildProviderCard({required String name, required String role, String? speciality}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(role),
            if (speciality != null && speciality.isNotEmpty)
              Text(speciality, style: TextStyle(color: AppPallete.greyColor)),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.remove_circle_outline),
          color: Colors.red,
          onPressed: widget.onRemove,
        ),
      ),
    );
  }
}
