import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthyways/core/common/custom_types/role.dart';
import 'package:healthyways/features/auth/presentation/controller/auth_controller.dart';
import 'package:healthyways/features/auth/presentation/widgets/role_card.dart';

class RoleSelectionPage extends StatelessWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => RoleSelectionPage());

  RoleSelectionPage({super.key});

  final AuthController _authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        // centers everything
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600), // page width
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Select Role.',
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Please select your role to continue.',
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 50),
                Wrap(
                  alignment: WrapAlignment.center, // center the cards
                  spacing: 20, // space between horizontally
                  runSpacing: 20, // space between rows if wrapped
                  children: [
                    RoleCard(
                      icon: Icons.health_and_safety,
                      roleName: "Doctor",
                      onTap: () => _authController.roleBasedLogin(Role.doctor),
                    ),
                    RoleCard(
                      icon: Icons.local_pharmacy,
                      roleName: "Pharmacist",
                      onTap:
                          () => _authController.roleBasedLogin(Role.pharmacist),
                    ),
                    RoleCard(
                      icon: Icons.person,
                      roleName: "Patient",
                      onTap: () => _authController.roleBasedLogin(Role.patient),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
