import 'package:flutter/material.dart';
import 'package:healthyways/core/theme/app_pallete.dart';

class RoleCard extends StatelessWidget {
  final IconData icon;
  final String roleName;
  final VoidCallback? onTap;
  const RoleCard({
    super.key,
    required this.icon,
    required this.roleName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 120,
        width: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [
              AppPallete.gradient1,
              AppPallete.gradient2,
              // AppPallete.gradient3,
            ],
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.white),
            SizedBox(height: 16),
            Text(
              roleName,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
