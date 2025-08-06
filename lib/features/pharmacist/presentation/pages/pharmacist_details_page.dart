import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthyways/core/common/controllers/app_profile_controller.dart';
import 'package:healthyways/core/theme/app_pallete.dart';
import 'package:healthyways/features/chat/presentation/controllers/chat_controller.dart';
import 'package:healthyways/features/pharmacist/presentation/controllers/pharmacist_controller.dart';

class PharmacistDetailsPage extends StatefulWidget {
  static route(String pharmacistId) => MaterialPageRoute(
    builder: (_) => PharmacistDetailsPage(pharmacistId: pharmacistId),
  );

  final String pharmacistId;
  const PharmacistDetailsPage({super.key, required this.pharmacistId});

  @override
  State<PharmacistDetailsPage> createState() => _PharmacistDetailsPageState();
}

class _PharmacistDetailsPageState extends State<PharmacistDetailsPage> {
  final PharmacistController _controller = Get.find();

  @override
  void initState() {
    super.initState();
    _controller.fetchPharmacistById(widget.pharmacistId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pharmacist Details'),
        backgroundColor: AppPallete.backgroundColor2,
      ),
      body: Obx(() {
        if (_controller.selectedPharmacist.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (_controller.selectedPharmacist.hasError) {
          return Center(
            child: Text(
              'Error: ${_controller.selectedPharmacist.error?.message}',
            ),
          );
        }

        final pharmacist = _controller.selectedPharmacist.data!;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Header
              Center(
                child: CircleAvatar(
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
              ),
              const SizedBox(height: 16),

              // Name
              Center(
                child: Text(
                  '${pharmacist.fName} ${pharmacist.lName}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Contact Information
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Contact Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ListTile(
                        leading: const Icon(Icons.email),
                        title: Text(pharmacist.email),
                      ),
                      if (pharmacist.address != null)
                        ListTile(
                          leading: const Icon(Icons.location_on),
                          title: Text(pharmacist.address!),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Chat Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final currentUserId =
                        Get.find<AppProfileController>().profile.data?.uid;
                    if (currentUserId == null) return;

                    final chatController = Get.find<ChatController>();

                    // For solo chat between current user and this patient
                    final participantIds = [widget.pharmacistId, currentUserId];
                    await chatController.openChatWith(participantIds);
                  },
                  icon: const Icon(Icons.chat_bubble_outline),
                  label: const Text('Message Pharmacist'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppPallete.gradient1,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
