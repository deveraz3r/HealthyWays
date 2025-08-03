import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthyways/core/common/controllers/app_profile_controller.dart';
import 'package:healthyways/core/common/entites/doctor_profile.dart';
import 'package:healthyways/core/theme/app_pallete.dart';
import 'package:healthyways/features/auth/presentation/controller/auth_controller.dart';
import 'package:healthyways/features/doctor/presentation/controllers/doctor_controller.dart';
import 'package:healthyways/core/common/models/doctor_profile_model.dart';

class DoctorProfilePage extends StatefulWidget {
  const DoctorProfilePage({super.key});

  @override
  State<DoctorProfilePage> createState() => _DoctorProfilePageState();
}

class _DoctorProfilePageState extends State<DoctorProfilePage> {
  final AppProfileController _appProfileController = Get.find();
  final DoctorController _doctorController = Get.find();

  late DoctorProfileModel doctor;

  final Map<String, bool> _editing = {};
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    final rawDoctor = _appProfileController.profile.data! as DoctorProfile;
    doctor = DoctorProfileModel(
      uid: rawDoctor.uid,
      email: rawDoctor.email,
      fName: rawDoctor.fName,
      lName: rawDoctor.lName,
      address: rawDoctor.address,
      gender: rawDoctor.gender,
      preferedLanguage: rawDoctor.preferedLanguage,
      selectedRole: rawDoctor.selectedRole,
      bio: rawDoctor.bio,
      specality: rawDoctor.specality,
      qualification: rawDoctor.qualification,
      rating: rawDoctor.rating,
    );

    _initController('fName', doctor.fName);
    _initController('lName', doctor.lName);
    _initController('email', doctor.email);
    _initController('address', doctor.address ?? '');
    _initController('gender', doctor.gender);
    _initController('language', doctor.preferedLanguage);
    _initController('bio', doctor.bio);
    _initController('specialty', doctor.specality);
    _initController('qualification', doctor.qualification);
  }

  void _initController(String key, String value) {
    _editing[key] = false;
    _controllers[key] = TextEditingController(text: value);
  }

  void _saveField(String fieldKey) {
    final updatedValue = _controllers[fieldKey]!.text;

    final updatedDoctor = doctor.copyWith(
      fName: fieldKey == 'fName' ? updatedValue : null,
      lName: fieldKey == 'lName' ? updatedValue : null,
      email: fieldKey == 'email' ? updatedValue : null,
      address: fieldKey == 'address' ? updatedValue : null,
      gender: fieldKey == 'gender' ? updatedValue : null,
      preferedLanguage: fieldKey == 'language' ? updatedValue : null,
      bio: fieldKey == 'bio' ? updatedValue : null,
      specality: fieldKey == 'specialty' ? updatedValue : null,
      qualification: fieldKey == 'qualification' ? updatedValue : null,
    );

    _doctorController.updateDoctor(updatedDoctor);
    setState(() {
      doctor = updatedDoctor;
      _editing[fieldKey] = false;
    });
  }

  Widget _buildEditableCard({
    required IconData icon,
    required String label,
    required String fieldKey,
    int maxLines = 1,
  }) {
    final isEditing = _editing[fieldKey]!;
    final controller = _controllers[fieldKey]!;

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
                  label,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(isEditing ? Icons.save : Icons.edit),
                  onPressed: () {
                    if (isEditing) {
                      _saveField(fieldKey);
                    } else {
                      setState(() => _editing[fieldKey] = true);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: controller,
              enabled: isEditing,
              maxLines: isEditing ? maxLines : 1,
              style: const TextStyle(fontSize: 16),
              decoration: InputDecoration(
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: false,
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
                          '${doctor.fName[0]}${doctor.lName[0]}',
                          style: const TextStyle(
                            fontSize: 35,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${doctor.fName} ${doctor.lName}',
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
                children: [
                  _buildEditableCard(
                    icon: Icons.person,
                    label: 'First Name',
                    fieldKey: 'fName',
                  ),
                  _buildEditableCard(
                    icon: Icons.person_outline,
                    label: 'Last Name',
                    fieldKey: 'lName',
                  ),
                  _buildEditableCard(
                    icon: Icons.email,
                    label: 'Email',
                    fieldKey: 'email',
                  ),
                  _buildEditableCard(
                    icon: Icons.location_on,
                    label: 'Address',
                    fieldKey: 'address',
                  ),
                  _buildEditableCard(
                    icon: Icons.transgender,
                    label: 'Gender',
                    fieldKey: 'gender',
                  ),
                  _buildEditableCard(
                    icon: Icons.language,
                    label: 'Preferred Language',
                    fieldKey: 'language',
                  ),
                  _buildEditableCard(
                    icon: Icons.school,
                    label: 'Qualification',
                    fieldKey: 'qualification',
                  ),
                  _buildEditableCard(
                    icon: Icons.business_center,
                    label: 'Specialty',
                    fieldKey: 'specialty',
                  ),
                  _buildEditableCard(
                    icon: Icons.info_outline,
                    label: 'Bio',
                    fieldKey: 'bio',
                    maxLines: 3,
                  ),

                  const SizedBox(height: 24),

                  ElevatedButton.icon(
                    onPressed: () {
                      // Replace with actual logout logic
                      // TODO: find a way to not use controller of another feature
                      Get.find<AuthController>().signOut();
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text('Logout'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppPallete.gradient1,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 14,
                      ),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
