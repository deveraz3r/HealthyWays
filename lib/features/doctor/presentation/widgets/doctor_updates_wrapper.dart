import 'package:flutter/material.dart';
import 'package:healthyways/core/common/custom_types/role.dart';
import 'package:healthyways/core/theme/app_pallete.dart';
import 'package:healthyways/features/updates/presentation/pages/updates_home_page.dart';

class DoctorUpdatesWrapper extends StatelessWidget {
  static route({required String uid}) =>
      MaterialPageRoute(builder: (_) => DoctorUpdatesWrapper(uid: uid));

  final String uid;
  const DoctorUpdatesWrapper({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Doctor Updates"),
        backgroundColor: AppPallete.backgroundColor2,
      ),
      body: UpdatesHomePage(uid: uid, role: Role.doctor),
    );
  }
}
