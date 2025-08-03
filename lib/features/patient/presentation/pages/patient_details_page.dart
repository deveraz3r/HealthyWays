import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthyways/core/common/entites/patient_profile.dart';
import 'package:healthyways/core/theme/app_pallete.dart';
import 'package:healthyways/features/allergies/presentation/controllers/allergie_controller.dart';
import 'package:healthyways/features/allergies/presentation/pages/allergy_home_page.dart';
import 'package:healthyways/features/diary/presentation/controllers/diary_controller.dart';
import 'package:healthyways/features/diary/presentation/pages/diary_home_page.dart';
import 'package:healthyways/features/doctor/presentation/widgets/doctor_updates_wrapper.dart';
import 'package:healthyways/features/immunization/presentation/controllers/immunization_controller.dart';
import 'package:healthyways/features/immunization/presentation/pages/immunization_home_page.dart';
import 'package:healthyways/features/measurements/presentation/controllers/measurement_controller.dart';
import 'package:healthyways/features/measurements/presentation/pages/measurement_details_page.dart';
import 'package:healthyways/features/measurements/presentation/pages/my_measurements_page.dart';
import 'package:healthyways/features/medication/presentation/pages/add_new_medication_page.dart';

class PatientDetailsPage extends StatelessWidget {
  static route(PatientProfile patient) =>
      MaterialPageRoute(builder: (_) => PatientDetailsPage(patient: patient));

  final PatientProfile patient;
  const PatientDetailsPage({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppPallete.backgroundColor2,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppPallete.gradient1.withOpacity(0.7),
                      AppPallete.backgroundColor2,
                    ],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: AppPallete.gradient1,
                        child: Text(
                          '${patient.fName[0]}${patient.lName[0]}',
                          style: const TextStyle(
                            fontSize: 35,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${patient.fName} ${patient.lName}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoCard(
                    icon: Icons.email,
                    title: 'Email',
                    content: patient.email,
                  ),
                  _buildInfoCard(
                    icon: Icons.person,
                    title: 'Gender',
                    content: patient.gender,
                  ),
                  if (patient.address != null)
                    _buildInfoCard(
                      icon: Icons.location_on,
                      title: 'Address',
                      content: patient.address!,
                    ),
                  _buildInfoCard(
                    icon: Icons.language,
                    title: 'Preferred Language',
                    content: patient.preferedLanguage,
                  ),
                  _buildInfoCard(
                    icon: Icons.people,
                    title: 'Marital Status',
                    content: patient.isMarried ? 'Married' : 'Single',
                  ),
                  if (patient.race != null)
                    _buildInfoCard(
                      icon: Icons.color_lens,
                      title: 'Race',
                      content: patient.race!,
                    ),
                  if (patient.emergencyContacts.isNotEmpty)
                    _buildInfoCard(
                      icon: Icons.contact_emergency,
                      title: 'Emergency Contacts',
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:
                            patient.emergencyContacts
                                .map((e) => Text(e))
                                .toList(),
                      ),
                    ),
                  const SizedBox(height: 16),
                  const Text(
                    'Patient Options',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _buildOptionTile(
                    'Allergies',
                    Icons.warning_amber_rounded,
                    () async {
                      final controller = Get.find<AllergiesController>();
                      controller.patientId.value = patient.uid;
                      controller.checkAllergyAccess(patient);
                      Navigator.push(context, AllergyHomePage.route());
                    },
                  ),
                  _buildOptionTile(
                    'Immunizations',
                    Icons.vaccines_rounded,
                    () async {
                      final controller = Get.find<ImmunizationController>();
                      controller.patientId.value = patient.uid;
                      controller.checkImmunizationAccess(patient);
                      Navigator.push(context, ImmunizationHomePage.route());
                    },
                  ),
                  _buildOptionTile(
                    'Measurements',
                    Icons.monitor_heart_rounded,
                    () {
                      // TODO: Add navigation
                      MeasurementController measurementController =
                          Get.find<MeasurementController>();
                      measurementController.patientProfile = patient;
                      measurementController.getMyMeasurements();
                      Navigator.push(context, MyMeasurementsPage.route());
                    },
                  ),
                  _buildOptionTile(
                    'Diary Entries',
                    Icons.menu_book_rounded,
                    () async {
                      final controller = Get.find<DiaryController>();
                      controller.patientId.value = patient.uid;
                      controller.checkDiaryAccess(patient);
                      Navigator.push(context, DiaryHomePage.route());
                    },
                  ),
                  _buildOptionTile(
                    'Medication History',
                    Icons.medication_rounded,
                    () {
                      Navigator.push(
                        context,
                        DoctorUpdatesWrapper.route(uid: patient.uid),
                      );
                    },
                  ),
                  _buildOptionTile(
                    'Assign Medicine',
                    Icons.medical_information,
                    () {
                      Navigator.push(
                        context,
                        AddNewMedicationPage.route(assignedTo: patient.uid),
                      );
                    },
                  ),
                  _buildOptionTile(
                    'Chat',
                    Icons.chat_bubble_outline_rounded,
                    () {
                      // TODO: Add chat navigation
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required dynamic content,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppPallete.gradient1),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            content is Widget
                ? content
                : Text(
                  content,
                  style: TextStyle(color: AppPallete.greyColor, fontSize: 16),
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppPallete.gradient1),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      tileColor: AppPallete.backgroundColor2.withOpacity(0.1),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }
}
