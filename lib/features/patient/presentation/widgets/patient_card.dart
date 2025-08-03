import 'package:flutter/material.dart';
import 'package:healthyways/core/common/entites/patient_profile.dart';
import 'package:healthyways/core/theme/app_pallete.dart';

class PatientCard extends StatelessWidget {
  final PatientProfile patient;
  final VoidCallback? onTap;

  const PatientCard({super.key, required this.patient, this.onTap});

  String _getInitials() {
    String initials = '';
    if (patient.fName.isNotEmpty) initials += patient.fName[0];
    if (patient.lName.isNotEmpty) initials += patient.lName[0];
    return initials.isNotEmpty ? initials.toUpperCase() : 'P';
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
              colors: [
                AppPallete.gradient1.withOpacity(0.2),
                AppPallete.backgroundColor2,
              ],
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: AppPallete.gradient1,
                child: Text(
                  _getInitials(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${patient.fName} ${patient.lName}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      patient.address ?? 'No address provided',
                      style: TextStyle(
                        color: AppPallete.greyColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
