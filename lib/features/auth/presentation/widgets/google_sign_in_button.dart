import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthyways/core/common/widgets/primary_gradient_button.dart';
import 'package:healthyways/features/auth/presentation/controller/auth_controller.dart';

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find();
    return PrimaryGradientButton(
      icon: Icons.account_box,
      buttonText: "Sign In with Google",
      onPressed: () => authController.signInWithGoogle(),
    );
  }
}
