import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthyways/core/common/custom_types/rating.dart';
import 'package:healthyways/core/common/entites/doctor_profile.dart';
import 'package:healthyways/core/theme/app_pallete.dart';
import 'package:healthyways/features/doctor/presentation/controllers/doctor_controller.dart';

class DoctorDetailsPage extends StatefulWidget {
  static route(String doctorId) => MaterialPageRoute(builder: (_) => DoctorDetailsPage(doctorId: doctorId));

  final String doctorId;
  const DoctorDetailsPage({super.key, required this.doctorId});

  @override
  State<DoctorDetailsPage> createState() => _DoctorDetailsPageState();
}

class _DoctorDetailsPageState extends State<DoctorDetailsPage> {
  final DoctorController _doctorController = Get.find();
  late DoctorProfile doctor;

  @override
  void initState() {
    super.initState();
    doctor = _doctorController.allDoctors.data!.firstWhere((doc) => doc.uid == widget.doctorId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            backgroundColor: AppPallete.backgroundColor2,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppPallete.gradient1.withOpacity(0.7), AppPallete.backgroundColor2],
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
                          style: const TextStyle(fontSize: 35, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Dr. ${doctor.fName} ${doctor.lName}',
                        style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Specialty Card
                  _buildInfoCard(
                    icon: Icons.medical_services_rounded,
                    title: 'Specialty',
                    content: doctor.specality.isEmpty ? 'General Physician' : doctor.specality,
                  ),
                  const SizedBox(height: 16),

                  // Qualification Card
                  _buildInfoCard(
                    icon: Icons.school_rounded,
                    title: 'Qualification',
                    content: doctor.qualification.isEmpty ? 'No qualification details available' : doctor.qualification,
                  ),
                  const SizedBox(height: 16),

                  // Bio Card
                  _buildInfoCard(
                    icon: Icons.person_outline_rounded,
                    title: 'About',
                    content: doctor.bio.isEmpty ? 'No bio available' : doctor.bio,
                  ),
                  const SizedBox(height: 16),

                  // Contact Info Card
                  _buildInfoCard(
                    icon: Icons.contact_mail_rounded,
                    title: 'Contact Information',
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildContactRow(Icons.email, doctor.email),
                        if (doctor.address != null) ...[
                          const SizedBox(height: 8),
                          _buildContactRow(Icons.location_on, doctor.address!),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Ratings and Reviews
                  if (doctor.rating.isNotEmpty) ...[
                    _buildInfoCard(
                      icon: Icons.star_rounded,
                      title: 'Ratings & Reviews',
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildRatingStats(doctor.rating),
                          const Divider(),
                          ...doctor.rating.map(_buildReviewItem),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Message Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Navigate to chat screen
                        // Navigator.push(context, ChatScreen.route(doctorId: doctor.uid));
                      },
                      icon: const Icon(Icons.chat_bubble_outline_rounded),
                      label: const Text('Message Doctor'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppPallete.gradient1,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
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

  Widget _buildInfoCard({required IconData icon, required String title, required dynamic content}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppPallete.gradient1),
                const SizedBox(width: 8),
                Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            content is Widget ? content : Text(content, style: TextStyle(color: AppPallete.greyColor, fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppPallete.greyColor),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: TextStyle(color: AppPallete.greyColor, fontSize: 16))),
      ],
    );
  }

  Widget _buildRatingStats(List<Rating> ratings) {
    double averageRating = ratings.isEmpty ? 0 : ratings.map((r) => r.stars).reduce((a, b) => a + b) / ratings.length;

    return Row(
      children: [
        Text(averageRating.toStringAsFixed(1), style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: List.generate(
                5,
                (index) => Icon(
                  index < averageRating ? Icons.star_rounded : Icons.star_border_rounded,
                  color: Colors.amber,
                  size: 24,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text('${ratings.length} reviews', style: TextStyle(color: AppPallete.greyColor, fontSize: 14)),
          ],
        ),
      ],
    );
  }

  Widget _buildReviewItem(Rating rating) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ...List.generate(
                5,
                (index) => Icon(
                  index < rating.stars ? Icons.star_rounded : Icons.star_border_rounded,
                  color: Colors.amber,
                  size: 16,
                ),
              ),
              const Spacer(),
              Text(
                '${rating.createdAt.day}/${rating.createdAt.month}/${rating.createdAt.year}',
                style: TextStyle(color: AppPallete.greyColor, fontSize: 12),
              ),
            ],
          ),
          if (rating.comment != null && rating.comment!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(rating.comment!, style: const TextStyle(fontSize: 14)),
          ],
        ],
      ),
    );
  }
}
