import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthyways/core/common/controllers/app_profile_controller.dart';
import 'package:healthyways/core/common/custom_types/role.dart';
import 'package:healthyways/core/theme/app_pallete.dart';
import 'package:healthyways/features/diary/presentation/pages/diary_home_page.dart';
import 'package:healthyways/features/medication/presentation/pages/add_new_medication_page.dart';
import 'package:healthyways/features/medication/presentation/pages/medications_home_page.dart';
import 'package:healthyways/features/patient/presentation/controllers/patient_controller.dart';
import 'package:healthyways/features/patient/presentation/pages/patient_more_page.dart';
import 'package:healthyways/features/patient/presentation/pages/patient_pill_and_measurement_page.dart';
import 'package:healthyways/features/patient/presentation/widgets/patient_drawer.dart';
import 'package:healthyways/features/updates/presentation/pages/updates_home_page.dart';

class PatientHomePage extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const PatientHomePage());
  const PatientHomePage({super.key});

  @override
  State<PatientHomePage> createState() => _PatientHomePageState();
}

class _PatientHomePageState extends State<PatientHomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    PatientPillAndMeasurementPage(),

    // MedicationsHomePage(),
    const PlaceholderPage(title: "Chats"),
    // DiaryHomePage(),

    // const PlaceholderPage(title: "Updates"),
    UpdatesHomePage(
      uid: Get.find<AppProfileController>().profile.data!.uid,
      role: Role.patient,
    ),

    const PlaceholderPage(title: "Med Cabinet"),

    const PlaceholderPage(
      title: "More",
    ), //Dummy placeholder as it is not a page
  ];

  @override
  void initState() {
    Get.find<PatientController>().getPatientById(
      Get.find<AppProfileController>().profile.data!.uid,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Healthy Ways"),
        actions: _patientHomeActionWidget(context, _currentIndex),
        backgroundColor: AppPallete.backgroundColor2,
      ),
      drawer: PatientDrawer(),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppPallete.backgroundColor2,
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 4) {
            //More page
            Navigator.push(context, PatientMorePage.route());
          } else {
            setState(() => _currentIndex = index);
          }
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.medication),
            label: "Pill Box",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chats"),
          BottomNavigationBarItem(icon: Icon(Icons.update), label: "Updates"),
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_services),
            label: "Med Cabinet",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: "More"),
        ],
      ),
    );
  }
}

//TODO: Delete following
class PlaceholderPage extends StatelessWidget {
  final String title;
  const PlaceholderPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(title, style: const TextStyle(fontSize: 24)));
  }
}

List<Widget> _patientHomeActionWidget(BuildContext context, int index) {
  // List<Widget> actionsList = [IconButton(onPressed: () {}, icon: Icon(CupertinoIcons.chat_bubble))];
  List<Widget> actionsList = [];

  switch (index) {
    case 0: // Pill Box
      actionsList.add(
        IconButton(
          icon: const Icon(CupertinoIcons.add),
          onPressed: () {
            Navigator.push(
              context,
              AddNewMedicationPage.route(
                assignedTo: Get.find<AppProfileController>().profile.data!.uid,
              ),
            );
          },
        ),
      );
    case 1: // Updates
      break;
    case 2: // Reports
      break;
    case 3: // Med Cabinet
      break;
    case 4: // More
      break;
    default:
      break;
  }

  return actionsList;
}
