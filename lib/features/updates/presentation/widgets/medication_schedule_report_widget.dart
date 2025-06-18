import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthyways/core/common/entites/assigned_medication_report.dart';
import 'package:healthyways/core/theme/app_pallete.dart';
import 'package:healthyways/features/updates/presentation/controllers/updates_controller.dart';
import 'package:healthyways/features/updates/presentation/pages/medication_schedule_details_page.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class MedicationScheduleCard extends StatefulWidget {
  final AssignedMedicationReport schedule;
  const MedicationScheduleCard({super.key, required this.schedule});

  @override
  State<MedicationScheduleCard> createState() => _MedicationScheduleCardState();
}

class _MedicationScheduleCardState extends State<MedicationScheduleCard> {
  final _updatesController = Get.find<UpdatesController>();
  String _assignerName = '';
  bool _isLoading = true;

  bool get isActive => DateTime.now().isBefore(widget.schedule.endDate);

  @override
  void initState() {
    super.initState();
    _loadAssignerDetails();
  }

  Future<void> _loadAssignerDetails() async {
    try {
      final patient = await _updatesController.getPatientById(id: widget.schedule.assignedBy);
      if (mounted) {
        setState(() {
          _assignerName = '${patient.fName} ${patient.lName}';
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _assignerName = 'Unknown';
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildAssignerName() {
    if (_isLoading) {
      return Shimmer.fromColors(
        baseColor: AppPallete.backgroundColor2,
        highlightColor: AppPallete.gradient1.withOpacity(0.2),
        child: Container(
          width: 120,
          height: 16,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
        ),
      );
    }
    return Text(_assignerName);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MedicationScheduleDetailsPage.route(schedule: widget.schedule));
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppPallete.gradient1.withOpacity(0.2), AppPallete.backgroundColor2],
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppPallete.backgroundColor2,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.medication, size: 32, color: AppPallete.gradient1),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              '${widget.schedule.medicines.length} Medicines',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color:
                                    isActive
                                        ? AppPallete.gradient1.withOpacity(0.1)
                                        : AppPallete.greyColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                isActive ? 'Active' : 'Inactive',
                                style: TextStyle(
                                  color: isActive ? AppPallete.gradient1 : AppPallete.greyColor,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 14, color: AppPallete.greyColor),
                            const SizedBox(width: 4),
                            Text(
                              'Until ${DateFormat('MMM d, y').format(widget.schedule.endDate)}',
                              style: const TextStyle(color: AppPallete.greyColor, fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text('Assigned By: ', style: TextStyle(color: AppPallete.greyColor)),
                  _buildAssignerName(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
