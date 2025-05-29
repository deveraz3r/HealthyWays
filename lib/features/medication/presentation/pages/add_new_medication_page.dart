import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthyways/core/common/entites/medicine.dart';
import 'package:healthyways/core/common/widgets/primary_gradient_button.dart';
import 'package:healthyways/core/theme/app_pallete.dart';
import 'package:healthyways/features/medication/presentation/controllers/medication_controller.dart';
import 'package:healthyways/features/medication/presentation/widgets/selected_medicine_card.dart';
import 'package:healthyways/init_dependences.dart';
import 'package:intl/intl.dart';

class AddNewMedicationPage extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (_) => const AddNewMedicationPage());
  const AddNewMedicationPage({super.key});

  @override
  State<AddNewMedicationPage> createState() => _AddNewMedicationPageState();
}

class _AddNewMedicationPageState extends State<AddNewMedicationPage> {
  final MedicationController medicationController = Get.put(
    serviceLocator<MedicationController>(),
  );

  final _searchController = TextEditingController();
  final _selectedMedicines = <Medicine>[].obs;
  bool _isSearching = false;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    medicationController.getAllMedicines();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Medications"),
        backgroundColor: AppPallete.backgroundColor2,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              //Medications Search Field
              TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() => _isSearching = value.isNotEmpty);
                },
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
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              //Medications Search Result List
              if (_isSearching)
                Expanded(
                  child: Obx(() {
                    if (medicationController.allMedicines.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final medicines =
                        medicationController.allMedicines.data
                            ?.where(
                              (med) => med.name.toLowerCase().contains(
                                _searchController.text.toLowerCase(),
                              ),
                            )
                            .toList() ??
                        [];

                    return ListView.builder(
                      itemCount: medicines.length,
                      itemBuilder: (_, index) {
                        final medicine = medicines[index];
                        return ListTile(
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Color(
                                int.parse(
                                  medicine.shape.primaryColorHex.substring(
                                    1,
                                    7,
                                  ),
                                  radix: 16,
                                ),
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.medication,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(medicine.name),
                          subtitle: Text('${medicine.dosage} ${medicine.unit}'),

                          onTap: () {
                            final isAlreadyAdded = _selectedMedicines.any(
                              (m) => m.id == medicine.id,
                            ); // or use a unique property

                            if (!isAlreadyAdded) {
                              _selectedMedicines.add(medicine);
                              _searchController.clear();
                              setState(() => _isSearching = false);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '${medicine.name} is already added',
                                  ),
                                  backgroundColor: Colors.orange,
                                ),
                              );
                            }
                          },
                        );
                      },
                    );
                  }),
                ),

              SizedBox(height: 10),

              //Selected Medicines List
              if (!_isSearching)
                Expanded(
                  child: Obx(
                    () => ListView.builder(
                      itemCount: _selectedMedicines.length,
                      itemBuilder: (_, index) {
                        final medicine = _selectedMedicines[index];
                        return SelectedMedicineCard(
                          medicine: medicine,
                          onRemove: () {
                            _selectedMedicines.removeAt(index);
                          },
                        );
                      },
                    ),
                  ),
                ),

              if (_selectedMedicines.isNotEmpty && !_isSearching) ...[
                SizedBox(height: 10),

                //Global End date picker
                InkWell(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _endDate ?? DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date != null) {
                      setState(() {
                        _endDate = date;
                      });
                    }
                  },
                  child: InputDecorator(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 16,
                      ),
                      suffixIcon: const Icon(Icons.calendar_today),
                    ),
                    child: Text(
                      _endDate != null
                          ? DateFormat('MMM d, y').format(_endDate!)
                          : 'Select end date',
                      style: TextStyle(
                        fontSize: 16,
                        color:
                            _endDate != null
                                ? Colors.white
                                : Colors.grey.shade500,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 10),

                //Assign medication button
                PrimaryGradientButton(
                  buttonText: "Assign Medications",
                  onPressed: _assignMedications,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _assignMedications() {
    // TODO: Implement medication assignment logic
  }
}
