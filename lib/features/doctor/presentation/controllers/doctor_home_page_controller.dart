import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthyways/core/common/controllers/app_profile_controller.dart';
import 'package:healthyways/core/common/custom_types/role.dart';
import 'package:healthyways/features/doctor/presentation/pages/doctor_main_screen.dart';
import 'package:healthyways/features/doctor/presentation/pages/doctor_profile_page.dart';
import 'package:healthyways/features/updates/presentation/pages/updates_home_page.dart';
import 'package:healthyways/features/doctor/presentation/pages/add_patient_page.dart';

class DoctorHomePageController extends GetxController {
  RxInt currentIndex = 0.obs;

  final RxList<Widget> pages = [
    const DoctorMainScreen(),
    const PlaceholderPage(title: "Chats"),
    UpdatesHomePage(
      uid: Get.find<AppProfileController>().profile.data!.uid,
      role: Role.doctor,
    ),
    const PlaceholderPage(title: "My Providers"),
    DoctorProfilePage(),
  ].obs;

  final RxList<BottomNavigationBarItem> bottomNavItems = [
    BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Home"),
    BottomNavigationBarItem(icon: Icon(Icons.forum), label: "Chats"),
    BottomNavigationBarItem(
      icon: Icon(Icons.notifications_active),
      label: "Updates",
    ),
    BottomNavigationBarItem(icon: Icon(Icons.people_alt), label: "My Patients"),
    BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profile"),
  ].obs;

  final RxList<Widget> appBarActions = <Widget>[].obs;

  @override
  void onInit() {
    super.onInit();
    _updateAppBarActions(currentIndex.value);
    ever(currentIndex, _updateAppBarActions); // React to tab changes
  }

  void setCurrentIndex(int value) {
    currentIndex.value = value;
  }

  void _updateAppBarActions(int index) {
    appBarActions.clear();

    if (index == 3) {
      // "My Patients" tab
      appBarActions.add(
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            Get.to(AddPatientPage.route());
          },
        ),
      );
    }
  }
}

// Placeholder (delete later if not needed)
class PlaceholderPage extends StatelessWidget {
  final String title;
  const PlaceholderPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(title, style: const TextStyle(fontSize: 24)));
  }
}
