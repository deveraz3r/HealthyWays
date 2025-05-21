import 'package:flutter/material.dart';

class AuthDropdownField extends StatelessWidget {
  final TextEditingController controller;
  final List<String> items;
  final String hintText;

  const AuthDropdownField({
    super.key,
    required this.controller,
    required this.items,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 15.0,
          horizontal: 10.0,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        filled: true,
        // fillColor: Colors.white,
      ),
      value: controller.text.isEmpty ? null : controller.text,
      hint: Text(hintText),
      items:
          items
              .map((item) => DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
      onChanged: (value) {
        controller.text = value ?? '';
      },
    );
  }
}
