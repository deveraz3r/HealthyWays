import 'package:flutter/material.dart';
import 'package:healthyways/core/common/entites/medicine.dart';
import 'package:healthyways/core/theme/app_pallete.dart';
import 'package:intl/intl.dart';

class SelectedMedicineCard extends StatefulWidget {
  final Medicine medicine;
  final VoidCallback onRemove;

  const SelectedMedicineCard({
    required this.medicine,
    required this.onRemove,
    super.key,
  });

  @override
  State<SelectedMedicineCard> createState() => _SelectedMedicineCardState();
}

class _SelectedMedicineCardState extends State<SelectedMedicineCard> {
  List<_TimeQuantitySlot> slots = [_TimeQuantitySlot()];
  String? repeatType;
  List<String> selectedWeekdays = [];
  List<DateTime> customDates = [];

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          ExpansionTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide.none,
            ),
            collapsedShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide.none,
            ),
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Color(
                  int.parse(
                    widget.medicine.shape.primaryColorHex.substring(1, 7),
                    radix: 16,
                  ),
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.medication, color: Colors.white),
            ),
            title: Text(widget.medicine.name),
            subtitle: Text('${widget.medicine.dosage} ${widget.medicine.unit}'),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Repeat Dropdown
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Repeat',
                        border: OutlineInputBorder(),
                      ),
                      value: repeatType,
                      items:
                          ['Daily', 'Week Days', 'Custom Dates']
                              .map(
                                (e) =>
                                    DropdownMenuItem(value: e, child: Text(e)),
                              )
                              .toList(),
                      onChanged: (value) {
                        setState(() {
                          repeatType = value;
                          selectedWeekdays.clear();
                          customDates.clear();
                        });
                      },
                    ),
                    const SizedBox(height: 12),

                    if (repeatType == 'Week Days') _buildWeekdaySelector(),
                    if (repeatType == 'Custom Dates') _buildCustomDatePicker(),

                    const SizedBox(height: 24),

                    // Dosage Schedule Header
                    Row(
                      children: [
                        const Text(
                          'Dosage Schedule',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.add,
                          size: 18,
                          color: Theme.of(context).primaryColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: slots.length,
                      itemBuilder: (context, index) {
                        final slot = slots[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppPallete.backgroundColor2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: slot.quantityController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    // labelText: 'Quantity',
                                    hintText: "Quantity",
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade400,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: InkWell(
                                  onTap: () async {
                                    final picked = await showTimePicker(
                                      context: context,
                                      initialTime: slot.time ?? TimeOfDay.now(),
                                    );
                                    if (picked != null) {
                                      setState(() {
                                        slot.time = picked;
                                      });
                                    }
                                  },
                                  child: InputDecorator(
                                    decoration: InputDecoration(
                                      // labelText: 'Time',
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey.shade400,
                                        ),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 22,
                                          ),
                                    ),
                                    child: Text(
                                      slot.time != null
                                          ? slot.time!.format(context)
                                          : 'Time of Day',
                                      style: TextStyle(
                                        color:
                                            slot.time != null
                                                ? Theme.of(
                                                  context,
                                                ).textTheme.bodyLarge?.color
                                                : Colors.grey.shade500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              if (slots.length > 1)
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline),
                                  onPressed: () {
                                    setState(() {
                                      slots.removeAt(index);
                                    });
                                  },
                                ),
                            ],
                          ),
                        );
                      },
                    ),

                    // Add Slot Button
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: () {
                          setState(() {
                            slots.add(_TimeQuantitySlot());
                          });
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Add Slot'),
                      ),
                    ),

                    // Remove Section
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: widget.onRemove,
                        icon: const Icon(
                          Icons.delete,
                          color: AppPallete.greyColor,
                        ),
                        label: const Text(
                          'Remove',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppPallete.greyColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeekdaySelector() {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return Wrap(
      spacing: 8,
      children:
          days.map((day) {
            final selected = selectedWeekdays.contains(day);
            return FilterChip(
              label: Text(day),
              selected: selected,
              onSelected: (bool value) {
                setState(() {
                  if (value) {
                    selectedWeekdays.add(day);
                  } else {
                    selectedWeekdays.remove(day);
                  }
                });
              },
            );
          }).toList(),
    );
  }

  Widget _buildCustomDatePicker() {
    return Column(
      children: [
        ...customDates.map((date) {
          return ListTile(
            title: Text(DateFormat.yMMMMd().format(date)),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                setState(() {
                  customDates.remove(date);
                });
              },
            ),
          );
        }),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            icon: const Icon(Icons.add),
            label: const Text("Add Date"),
            onPressed: () async {
              final date = await showDatePicker(
                context: context,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
                initialDate: DateTime.now(),
              );
              if (date != null && !customDates.contains(date)) {
                setState(() {
                  customDates.add(date);
                });
              }
            },
          ),
        ),
      ],
    );
  }
}

class _TimeQuantitySlot {
  TimeOfDay? time;
  final TextEditingController quantityController = TextEditingController();
}
