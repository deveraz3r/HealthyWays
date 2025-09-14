import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthyways/core/common/custom_types/role.dart';
import 'package:healthyways/core/common/controllers/app_profile_controller.dart';
import 'package:healthyways/features/chat/presentation/pages/chat_rooms_page.dart';
import 'package:healthyways/features/patient/presentation/pages/all_patients_page.dart';
import 'package:healthyways/features/patient/presentation/pages/my_patients_page.dart';
import 'package:healthyways/features/permission_requests/presentation/pages/permission_request_page.dart';
import 'package:healthyways/features/pharmacist/presentation/pages/pharmacist_profile_page.dart';

class PharmacistHomePageController extends GetxController {
  RxInt currentIndex = 0.obs;

  final RxList<Widget> pages =
      [
        AllPatientsPage(),
        MyPatientsPage(),
        ChatRoomsPage(),
        PermissionRequestsPage(),
        PharmacistProfilePage(),
      ].obs;

  final RxList<BottomNavigationBarItem> bottomNavItems =
      [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: "All Patients",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people_alt),
          label: "My Patients",
        ),
        BottomNavigationBarItem(icon: Icon(Icons.forum), label: "Chats"),
        BottomNavigationBarItem(
          icon: Icon(Icons.send_time_extension),
          label: "Requests",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: "Profile",
        ),
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

    // You can add condition-specific actions here if needed
    // if (index == 1) {
    //   appBarActions.add(
    //     IconButton(
    //       icon: Icon(Icons.add),
    //       onPressed: () {
    //         // Add patient logic here
    //       },
    //     ),
    //   );
    // }
  }
}
