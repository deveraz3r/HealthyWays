import 'package:flutter/material.dart';

class AuthField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool? obscureText;

  const AuthField({
    super.key,
    required this.hintText,
    required this.controller,
    this.keyboardType,
    this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText ?? false,
      decoration: InputDecoration(
        hintText: hintText,
        // contentPadding: EdgeInsets.all(20),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return "Please enter your $hintText";
        }
        return null;
      },
    );
  }
}
