import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthyways/core/common/controllers/app_profile_controller.dart';
import 'package:healthyways/core/common/entites/pharmacist_profile.dart';
import 'package:healthyways/core/theme/app_pallete.dart';
import 'package:healthyways/features/auth/data/models/pharmacist_profile_model.dart';
import 'package:healthyways/features/auth/presentation/controller/auth_controller.dart';
// import 'package:healthyways/core/common/models/pharmacist_profile_model.dart';
import 'package:healthyways/features/pharmacist/presentation/controllers/pharmacist_controller.dart';

class PharmacistProfilePage extends StatefulWidget {
  const PharmacistProfilePage({super.key});

  @override
  State<PharmacistProfilePage> createState() => _PharmacistProfilePageState();
}

class _PharmacistProfilePageState extends State<PharmacistProfilePage> {
  final AppProfileController _appProfileController = Get.find();
  final PharmacistController _pharmacistController = Get.find();

  late PharmacistProfileModel pharmacist;

  final Map<String, bool> _editing = {};
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    final rawPharmacist =
        _appProfileController.profile.data! as PharmacistProfile;

    pharmacist = PharmacistProfileModel(
      uid: rawPharmacist.uid,
      email: rawPharmacist.email,
      fName: rawPharmacist.fName,
      lName: rawPharmacist.lName,
      address: rawPharmacist.address,
      gender: rawPharmacist.gender,
      preferedLanguage: rawPharmacist.preferedLanguage,
      selectedRole: rawPharmacist.selectedRole,
      // bio: rawPharmacist.bio,
      // qualification: rawPharmacist.qualification,
    );

    _initController('fName', pharmacist.fName);
    _initController('lName', pharmacist.lName);
    _initController('email', pharmacist.email);
    _initController('address', pharmacist.address ?? '');
    _initController('gender', pharmacist.gender);
    _initController('language', pharmacist.preferedLanguage);
    // _initController('bio', pharmacist.bio);
    // _initController('qualification', pharmacist.qualification);
  }

  void _initController(String key, String value) {
    _editing[key] = false;
    _controllers[key] = TextEditingController(text: value);
  }

  void _saveField(String fieldKey) {
    final updatedValue = _controllers[fieldKey]!.text;

    final updatedPharmacist = pharmacist.copyWith(
      fName: fieldKey == 'fName' ? updatedValue : null,
      lName: fieldKey == 'lName' ? updatedValue : null,
      email: fieldKey == 'email' ? updatedValue : null,
      address: fieldKey == 'address' ? updatedValue : null,
      gender: fieldKey == 'gender' ? updatedValue : null,
      preferedLanguage: fieldKey == 'language' ? updatedValue : null,
      // bio: fieldKey == 'bio' ? updatedValue : null,
      // qualification: fieldKey == 'qualification' ? updatedValue : null,
    );

    _pharmacistController.updatePharmacist(updatedPharmacist);

    setState(() {
      pharmacist = updatedPharmacist;
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
                          '${pharmacist.fName[0]}${pharmacist.lName[0]}',
                          style: const TextStyle(
                            fontSize: 35,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${pharmacist.fName} ${pharmacist.lName}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        pharmacist.selectedRole.name.capitalizeFirst ?? '',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
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
                  // _buildEditableCard(
                  //   icon: Icons.school,
                  //   label: 'Qualification',
                  //   fieldKey: 'qualification',
                  // ),
                  // _buildEditableCard(
                  //   icon: Icons.info_outline,
                  //   label: 'Bio',
                  //   fieldKey: 'bio',
                  //   maxLines: 3,
                  // ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
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
