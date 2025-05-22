import 'package:flutter/material.dart';
import 'package:healthyways/core/theme/app_pallete.dart';

class PatientMorePage extends StatelessWidget {
  static route() => MaterialPageRoute(builder: (context) => PatientMorePage());
  const PatientMorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: AppPallete.backgroundColor2),
      body: Center(child: Text("Patient More Pages")),
    );
  }
}
