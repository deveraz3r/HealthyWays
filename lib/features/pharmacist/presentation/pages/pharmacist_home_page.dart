import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthyways/core/common/controllers/app_profile_controller.dart';
import 'package:healthyways/core/theme/app_pallete.dart';
import 'package:healthyways/features/pharmacist/presentation/controllers/pharmacist_home_page_controller.dart';
import 'package:healthyways/features/patient/presentation/controllers/patient_controller.dart';

class PharmacistHomePage extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const PharmacistHomePage());
  const PharmacistHomePage({super.key});

  @override
  State<PharmacistHomePage> createState() => _PharmacistHomePageState();
}

class _PharmacistHomePageState extends State<PharmacistHomePage> {
  final PharmacistHomePageController _controller = Get.put(
    PharmacistHomePageController(),
  );

  @override
  void initState() {
    super.initState();
    Get.find<PatientController>().getPatientById(
      Get.find<AppProfileController>().profile.data!.uid,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Healthy Ways"),
        backgroundColor: AppPallete.backgroundColor2,
        actions: _controller.appBarActions,
      ),
      body: Obx(() => _controller.pages[_controller.currentIndex.value]),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppPallete.backgroundColor2,
        currentIndex: _controller.currentIndex.value,
        onTap: _controller.setCurrentIndex,
        type: BottomNavigationBarType.fixed,
        items: _controller.bottomNavItems,
      ),
    );
  }
}
