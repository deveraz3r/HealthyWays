import 'package:flutter/material.dart';
import 'package:healthyways/core/common/entites/pharmacist_profile.dart';
import 'package:healthyways/core/theme/app_pallete.dart';

class PharmacistCard extends StatelessWidget {
  final PharmacistProfile pharmacist;
  final VoidCallback? onTap;

  const PharmacistCard({super.key, required this.pharmacist, this.onTap});

  String _getInitials() {
    String initials = '';
    if (pharmacist.fName.isNotEmpty) {
      initials += pharmacist.fName[0];
    }
    if (pharmacist.lName.isNotEmpty) {
      initials += pharmacist.lName[0];
    }
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
              colors: [AppPallete.gradient1.withOpacity(0.2), AppPallete.backgroundColor2],
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
                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${pharmacist.fName} ${pharmacist.lName}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    if (pharmacist.address != null) ...[
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 16, color: AppPallete.greyColor),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              pharmacist.address!,
                              style: TextStyle(color: AppPallete.greyColor, fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ],
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
