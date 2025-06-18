import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthyways/core/common/entites/assigned_medication_report.dart';
import 'package:healthyways/core/common/entites/medicine.dart';
import 'package:healthyways/core/common/entites/medicine_schedule.dart';
import 'package:healthyways/core/theme/app_pallete.dart';
import 'package:healthyways/features/updates/presentation/controllers/updates_controller.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class MedicationScheduleDetailsPage extends StatefulWidget {
  static route({required AssignedMedicationReport schedule}) =>
      MaterialPageRoute(builder: (_) => MedicationScheduleDetailsPage(schedule: schedule));

  final AssignedMedicationReport schedule;
  const MedicationScheduleDetailsPage({super.key, required this.schedule});

  @override
  State<MedicationScheduleDetailsPage> createState() => _MedicationScheduleDetailsPageState();
}

class _MedicationScheduleDetailsPageState extends State<MedicationScheduleDetailsPage> {
  final _updatesController = Get.find<UpdatesController>();
  final _medicineDetails = <String, Medicine>{}.obs;
  String _assignerName = '';
  bool _isLoading = true;
  bool _loadingMedicines = true;

  @override
  void initState() {
    super.initState();
    _loadAssignerDetails();
    _loadMedicineDetails();
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

  Future<void> _loadMedicineDetails() async {
    try {
      for (final schedule in widget.schedule.medicines) {
        final medicine = await _updatesController.getMedicineById(id: schedule.medicineId);
        if (medicine != null) {
          _medicineDetails[schedule.medicineId] = medicine;
        }
      }
    } catch (e) {
      debugPrint('Error loading medicine details: $e');
    } finally {
      if (mounted) {
        setState(() => _loadingMedicines = false);
      }
    }
  }

  Widget _buildShimmer({double width = double.infinity, required double height}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildMedicineScheduleCard(MedicineSchedule schedule) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        // Remove default dividers
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        backgroundColor: Colors.transparent,
        // Remove divider color
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title:
            _loadingMedicines
                ? _buildShimmer(height: 24)
                : Text(
                  _medicineDetails[schedule.medicineId]?.name ?? 'Unknown Medicine',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
        subtitle:
            _loadingMedicines
                ? _buildShimmer(width: 100, height: 16)
                : Text(
                  '${_medicineDetails[schedule.medicineId]?.dosage ?? ''} '
                  '${_medicineDetails[schedule.medicineId]?.unit ?? ''}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
        leading: CircleAvatar(
          backgroundColor: Color(
            int.parse(
              _medicineDetails[schedule.medicineId]?.shape.primaryColorHex.substring(1, 7) ?? 'FFFFFF',
              radix: 16,
            ),
          ),
          child: const Icon(Icons.medication, color: Colors.white),
        ),
        // Set initially collapsed
        initiallyExpanded: false,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Repetition Type
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.withOpacity(0.3)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.repeat, size: 20),
                      const SizedBox(width: 8),
                      Text('Repeats: ${schedule.repetitionType.name}', style: const TextStyle(fontSize: 15)),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Weekdays section
                if (schedule.weekdays?.isNotEmpty ?? false) ...[
                  const Text('Selected Days', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        schedule.weekdays!.map((day) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppPallete.gradient1.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppPallete.gradient1.withOpacity(0.3)),
                            ),
                            child: Text(
                              day,
                              style: TextStyle(color: AppPallete.gradient1, fontWeight: FontWeight.w500),
                            ),
                          );
                        }).toList(),
                  ),
                  const SizedBox(height: 16),
                ],

                // Custom Dates section
                if (schedule.customDates?.isNotEmpty ?? false) ...[
                  const Text('Selected Dates', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        schedule.customDates!.map((date) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppPallete.gradient1.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppPallete.gradient1.withOpacity(0.3)),
                            ),
                            child: Text(
                              DateFormat('MMM d').format(date),
                              style: TextStyle(color: AppPallete.gradient1, fontWeight: FontWeight.w500),
                            ),
                          );
                        }).toList(),
                  ),
                  const SizedBox(height: 16),
                ],

                // Intake Instructions section
                const Text('Intake Times', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                ...schedule.intakeInstruction.map((inst) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.withOpacity(0.3)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.access_time, size: 20),
                        const SizedBox(width: 12),
                        Text(inst.time.format(context), style: const TextStyle(fontSize: 15)),
                        const Spacer(),
                        Text(
                          '${inst.quantity} ${_loadingMedicines ? '...' : _medicineDetails[schedule.medicineId]?.unit ?? 'units'}',
                          style: const TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Medication Details'), backgroundColor: AppPallete.backgroundColor2),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('Assigned By: ', style: TextStyle(fontSize: 16)),
                        if (_isLoading)
                          _buildShimmer(width: 120, height: 20)
                        else
                          Text(_assignerName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Start Date: ${DateFormat('MMM d, y').format(widget.schedule.startDate)}',
                      style: const TextStyle(fontSize: 15),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'End Date: ${DateFormat('MMM d, y').format(widget.schedule.endDate)}',
                      style: const TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ...widget.schedule.medicines.map(_buildMedicineScheduleCard),
          ],
        ),
      ),
    );
  }
}
