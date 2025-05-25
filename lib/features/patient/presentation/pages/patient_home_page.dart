import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthyways/core/theme/app_pallete.dart';
import 'package:healthyways/features/medication/presentation/pages/medications_home_page.dart';
import 'package:healthyways/features/patient/presentation/pages/patient_more_page.dart';
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
    MedicationsHomePage(),
    UpdatesHomePage(),
    // const PlaceholderPage(title: "Updates"),
    const PlaceholderPage(title: "Reports"),
    const PlaceholderPage(title: "Med Cabinet"),
    const PlaceholderPage(title: "More"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Healthy Ways"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(CupertinoIcons.chat_bubble_2_fill),
          ),
        ],
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
          BottomNavigationBarItem(icon: Icon(Icons.update), label: "Updates"),
          BottomNavigationBarItem(
            icon: Icon(Icons.insert_chart),
            label: "Reports",
          ),
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

// List<Widget> _patientHomeActionWidget(int index) {
//   switch (index) {
//     case 0: // Pill Box
//       return [
//         IconButton(
//           icon: const Icon(CupertinoIcons.add),
//           onPressed: () {
//             // Example: Add new pill
//           },
//         ),
//       ];
//     case 1: // Updates
//       return [];
//     case 2: // Reports
//       return [];
//     case 3: // Med Cabinet
//       return [];
//     case 4: // More
//       return [];
//     default:
//       return [];
//   }
// }
