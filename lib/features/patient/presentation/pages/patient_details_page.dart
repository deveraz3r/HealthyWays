import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthyways/core/common/controllers/app_profile_controller.dart';
import 'package:healthyways/core/common/entites/patient_profile.dart';
import 'package:healthyways/core/theme/app_pallete.dart';
import 'package:healthyways/features/allergies/presentation/controllers/allergie_controller.dart';
import 'package:healthyways/features/allergies/presentation/pages/allergy_home_page.dart';
import 'package:healthyways/features/chat/presentation/controllers/chat_controller.dart';
import 'package:healthyways/features/diary/presentation/controllers/diary_controller.dart';
import 'package:healthyways/features/diary/presentation/pages/diary_home_page.dart';
import 'package:healthyways/features/doctor/presentation/widgets/doctor_updates_wrapper.dart';
import 'package:healthyways/features/immunization/presentation/controllers/immunization_controller.dart';
import 'package:healthyways/features/immunization/presentation/pages/immunization_home_page.dart';
import 'package:healthyways/features/measurements/presentation/controllers/measurement_controller.dart';
import 'package:healthyways/features/measurements/presentation/pages/my_measurements_page.dart';
import 'package:healthyways/features/medication/presentation/pages/add_new_medication_page.dart';
import 'package:healthyways/features/patient/presentation/controllers/patient_controller.dart';
import 'package:healthyways/features/permission_requests/presentation/controllers/premission_request_controller.dart';

class PatientDetailsPage extends StatefulWidget {
  static route(PatientProfile patient) =>
      MaterialPageRoute(builder: (_) => PatientDetailsPage(patient: patient));

  final PatientProfile patient;
  const PatientDetailsPage({super.key, required this.patient});

  @override
  State<PatientDetailsPage> createState() => _PatientDetailsPageState();
}

class _PatientDetailsPageState extends State<PatientDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final currentUser = Get.find<AppProfileController>().profile.data!;
    final isProvider = widget.patient.myProviders.contains(currentUser.uid);

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
                          '${widget.patient.fName[0]}${widget.patient.lName[0]}',
                          style: const TextStyle(
                            fontSize: 35,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${widget.patient.fName} ${widget.patient.lName}',
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
                    content: widget.patient.email,
                  ),
                  _buildInfoCard(
                    icon: Icons.person,
                    title: 'Gender',
                    content: widget.patient.gender,
                  ),
                  if (widget.patient.address != null)
                    _buildInfoCard(
                      icon: Icons.location_on,
                      title: 'Address',
                      content: widget.patient.address!,
                    ),
                  _buildInfoCard(
                    icon: Icons.language,
                    title: 'Preferred Language',
                    content: widget.patient.preferedLanguage,
                  ),
                  _buildInfoCard(
                    icon: Icons.people,
                    title: 'Marital Status',
                    content: widget.patient.isMarried ? 'Married' : 'Single',
                  ),
                  if (widget.patient.race != null)
                    _buildInfoCard(
                      icon: Icons.color_lens,
                      title: 'Race',
                      content: widget.patient.race!,
                    ),
                  if (widget.patient.emergencyContacts.isNotEmpty)
                    _buildInfoCard(
                      icon: Icons.contact_emergency,
                      title: 'Emergency Contacts',
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:
                            widget.patient.emergencyContacts
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
                      controller.patientId.value = widget.patient.uid;
                      controller.checkAllergyAccess(widget.patient);
                      Navigator.push(context, AllergyHomePage.route());
                    },
                  ),
                  _buildOptionTile(
                    'Immunizations',
                    Icons.vaccines_rounded,
                    () async {
                      final controller = Get.find<ImmunizationController>();
                      controller.patientId.value = widget.patient.uid;
                      controller.checkImmunizationAccess(widget.patient);
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
                      measurementController.patientProfile = widget.patient;
                      measurementController.getMyMeasurements();
                      Navigator.push(context, MyMeasurementsPage.route());
                    },
                  ),
                  _buildOptionTile(
                    'Diary Entries',
                    Icons.menu_book_rounded,
                    () async {
                      final controller = Get.find<DiaryController>();
                      controller.patientId.value = widget.patient.uid;
                      controller.checkDiaryAccess(widget.patient);
                      Navigator.push(context, DiaryHomePage.route());
                    },
                  ),
                  _buildOptionTile(
                    'Medication History',
                    Icons.medication_rounded,
                    () {
                      Navigator.push(
                        context,
                        DoctorUpdatesWrapper.route(uid: widget.patient.uid),
                      );
                    },
                  ),
                  _buildOptionTile(
                    'Assign Medicine',
                    Icons.medical_information,
                    () {
                      Navigator.push(
                        context,
                        AddNewMedicationPage.route(
                          assignedTo: widget.patient.uid,
                        ),
                      );
                    },
                  ),
                  _buildOptionTile(
                    'Chat',
                    Icons.chat_bubble_outline_rounded,
                    () async {
                      final currentUserId =
                          Get.find<AppProfileController>().profile.data?.uid;
                      if (currentUserId == null) return;

                      final chatController = Get.find<ChatController>();

                      // For solo chat between current user and this patient
                      final participantIds = [
                        widget.patient.uid,
                        currentUserId,
                      ];
                      await chatController.openChatWith(participantIds);
                    },
                  ),

                  _buildOptionTile(
                    isProvider ? 'Remove Provider' : 'Add as Provider',
                    isProvider ? Icons.person_remove : Icons.person_add,
                    () async {
                      final patientController = Get.find<PatientController>();
                      final permissionRequestController =
                          Get.find<PermissionRequestController>();
                      if (isProvider) {
                        setState(() {
                          widget.patient.myProviders.remove(currentUser.uid);
                        });
                        await patientController.updatePatient(widget.patient);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Removed as provider')),
                        );
                      } else {
                        await permissionRequestController.createRequest(
                          patientId: widget.patient.uid,
                          providerId: currentUser.uid,
                          createdByRole: currentUser.selectedRole,
                        );
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   SnackBar(content: Text('Permission request sent')),
                        // );
                      }
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
