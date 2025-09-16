import 'package:flutter/material.dart';
import 'package:healthyways/core/theme/app_pallete.dart';

class PrimaryGradientButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;

  /// ✅ Optional: custom gradient colors (fallback to AppPallete)
  final List<Color>? colors;

  /// ✅ Optional: add an icon (fallback = none)
  final IconData? icon;

  const PrimaryGradientButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
    this.colors,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final gradientColors =
        colors ??
        [
          AppPallete.gradient1,
          AppPallete.gradient2,
          // AppPallete.gradient3,
        ];

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: gradientColors,
        ),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          fixedSize: const Size(390, 50),
          backgroundColor: AppPallete.transparentColor,
          shadowColor: AppPallete.transparentColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white, size: 24),
              const SizedBox(width: 8),
            ],
            Text(
              buttonText,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
