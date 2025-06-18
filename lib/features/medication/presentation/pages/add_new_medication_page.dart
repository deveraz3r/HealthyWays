import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthyways/core/common/controllers/app_profile_controller.dart';
import 'package:healthyways/core/common/entites/medicine.dart';
import 'package:healthyways/core/common/widgets/primary_gradient_button.dart';
import 'package:healthyways/core/theme/app_pallete.dart';
import 'package:healthyways/core/common/entites/assigned_medication_report.dart';
import 'package:healthyways/core/common/entites/medicine_schedule.dart';
import 'package:healthyways/features/medication/presentation/controllers/medication_controller.dart';
import 'package:healthyways/features/medication/presentation/widgets/selected_medicine_card.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class AddNewMedicationPage extends StatefulWidget {
  static route({required String assignedTo}) =>
      MaterialPageRoute(builder: (_) => AddNewMedicationPage(assignedTo: assignedTo));
  const AddNewMedicationPage({super.key, required this.assignedTo});

  final String assignedTo;

  @override
  State<AddNewMedicationPage> createState() => _AddNewMedicationPageState();
}

class _AddNewMedicationPageState extends State<AddNewMedicationPage> {
  final _searchController = TextEditingController();
  final _selectedMedicines = <Medicine>[].obs;
  final _medicineSchedules = <String, MedicineSchedule>{};
  DateTime? _globalEndDate;
  final MedicationController _controller = Get.find<MedicationController>();
  final AppProfileController _appProfileController = Get.find();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _controller.getAllMedicines();
  }

  void _assignMedications() {
    if (_selectedMedicines.isEmpty ||
        _medicineSchedules.length != _selectedMedicines.length ||
        _globalEndDate == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Make sure all medicines have schedule and end date is selected')));
      return;
    }

    final assignedMedication = AssignedMedicationReport(
      id: const Uuid().v4(),
      assignedTo: widget.assignedTo,
      assignedBy: _appProfileController.profile.data!.uid,
      startDate: DateTime.now(),
      endDate: _globalEndDate!,
      medicines: _medicineSchedules.values.toList(),
    );

    _controller.assignMedication(assignedMedication);
    Navigator.pop(context);
  }

  void _updateMedicineSchedule(Medicine medicine, MedicineSchedule schedule) {
    _medicineSchedules[medicine.id] = schedule;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Medications"), backgroundColor: AppPallete.backgroundColor2),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                onChanged: (value) => setState(() => _isSearching = value.isNotEmpty),
                decoration: InputDecoration(
                  hintText: 'Add medicines...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon:
                      _isSearching
                          ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _isSearching = false);
                            },
                          )
                          : null,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              if (_isSearching)
                Expanded(
                  child: Obx(() {
                    if (_controller.allMedicines.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final meds =
                        _controller.allMedicines.data!
                            .where((med) => med.name.toLowerCase().contains(_searchController.text.toLowerCase()))
                            .toList();

                    return ListView.builder(
                      itemCount: meds.length,
                      itemBuilder: (_, index) {
                        final med = meds[index];
                        return ListTile(
                          title: Text(med.name),
                          subtitle: Text('${med.dosage} ${med.unit}'),
                          onTap: () {
                            if (!_selectedMedicines.any((m) => m.id == med.id)) {
                              _selectedMedicines.add(med);
                              _searchController.clear();
                              setState(() => _isSearching = false);
                            } else {
                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(SnackBar(content: Text('${med.name} is already added')));
                            }
                          },
                        );
                      },
                    );
                  }),
                )
              else
                Expanded(
                  child: Obx(() {
                    return ListView.builder(
                      itemCount: _selectedMedicines.length,
                      itemBuilder: (_, index) {
                        final medicine = _selectedMedicines[index];
                        return SelectedMedicineCard(
                          medicine: medicine,
                          onRemove: () {
                            _selectedMedicines.removeAt(index);
                            _medicineSchedules.remove(medicine.id);
                          },
                          onScheduleChanged: _updateMedicineSchedule,
                        );
                      },
                    );
                  }),
                ),

              if (_selectedMedicines.isNotEmpty && !_isSearching) ...[
                const SizedBox(height: 16),
                InkWell(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _globalEndDate ?? DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date != null) {
                      setState(() => _globalEndDate = date);
                    }
                  },
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Global End Date',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      suffixIcon: const Icon(Icons.calendar_today, size: 20),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    child: Text(
                      _globalEndDate != null ? DateFormat('MMM d, y').format(_globalEndDate!) : 'Select end date',
                      style: TextStyle(
                        fontSize: 14,
                        color: _globalEndDate != null ? Colors.white : Colors.grey.shade500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                PrimaryGradientButton(buttonText: "Assign Medications", onPressed: _assignMedications),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
