import 'package:flutter/material.dart';
import 'package:healthyways/core/common/entites/doctor_profile.dart';
import 'package:healthyways/core/theme/app_pallete.dart';

class DoctorCard extends StatelessWidget {
  final DoctorProfile doctor;
  final VoidCallback? onTap;

  const DoctorCard({super.key, required this.doctor, this.onTap});

  String _getInitials() {
    String initials = '';
    if (doctor.fName.isNotEmpty) {
      initials += doctor.fName[0];
    }
    if (doctor.lName.isNotEmpty) {
      initials += doctor.lName[0];
    }
    return initials.isNotEmpty ? initials.toUpperCase() : 'D';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppPallete.gradient1.withOpacity(0.2), AppPallete.backgroundColor2],
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppPallete.gradient1,
                    child: Text(
                      _getInitials(),
                      style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dr. ${doctor.fName} ${doctor.lName}',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          doctor.specality.isEmpty ? 'General Physician' : doctor.specality,
                          style: TextStyle(color: AppPallete.greyColor, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: AppPallete.greyColor),
                  const SizedBox(width: 4),
                  Text(
                    doctor.address ?? 'Location not specified',
                    style: TextStyle(color: AppPallete.greyColor, fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
