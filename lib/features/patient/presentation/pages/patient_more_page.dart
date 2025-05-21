import 'package:flutter/material.dart';

class PatientMorePage extends StatelessWidget {
  static route() => MaterialPageRoute(builder: (context) => PatientMorePage());
  const PatientMorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(child: Text("Patient More Pages")),
    );
  }
}
