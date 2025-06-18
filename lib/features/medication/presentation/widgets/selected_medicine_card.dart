import 'package:flutter/material.dart';
import 'package:healthyways/core/common/custom_types/repetition_type.dart';
import 'package:healthyways/core/common/entites/medicine.dart';
import 'package:healthyways/core/common/entites/medicine_schedule.dart';
import 'package:intl/intl.dart';

class SelectedMedicineCard extends StatefulWidget {
  final Medicine medicine;
  final VoidCallback onRemove;
  final Function(Medicine, MedicineSchedule) onScheduleChanged;

  const SelectedMedicineCard({
    required this.medicine,
    required this.onRemove,
    required this.onScheduleChanged,
    super.key,
  });

  @override
  State<SelectedMedicineCard> createState() => _SelectedMedicineCardState();
}

class _SelectedMedicineCardState extends State<SelectedMedicineCard> {
  String _repetitionType = 'Daily';
  List<String> _selectedWeekdays = [];
  List<DateTime> _customDates = [];
  List<_TimeQuantitySlot> _slots = [_TimeQuantitySlot()];
  bool _isExpanded = true;

  void _updateSchedule() {
    final intakeInstructions =
        _slots
            .where((slot) => slot.time != null && slot.quantityController.text.isNotEmpty)
            .map(
              (slot) =>
                  IntakeInstruction(time: slot.time!, quantity: double.tryParse(slot.quantityController.text) ?? 0),
            )
            .toList();

    widget.onScheduleChanged(
      widget.medicine,
      MedicineSchedule(
        medicineId: widget.medicine.id,
        intakeInstruction: intakeInstructions,
        repetitionType: _getRepetitionTypeEnum(),
        weekdays: _repetitionType == 'Weekdays' ? _selectedWeekdays : null,
        customDates: _repetitionType == 'Custom Dates' ? _customDates : null,
      ),
    );
  }

  RepetitionType _getRepetitionTypeEnum() {
    switch (_repetitionType) {
      case 'Daily':
        return RepetitionType.daily;
      case 'Weekdays':
        return RepetitionType.weekdays;
      case 'Custom Dates':
        return RepetitionType.customDates;
      default:
        throw Exception('Invalid repetition type');
    }
  }

  @override
  void dispose() {
    for (var slot in _slots) {
      slot.quantityController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        title: Text(widget.medicine.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        initiallyExpanded: true,
        onExpansionChanged: (val) => setState(() => _isExpanded = val),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${widget.medicine.dosage} ${widget.medicine.unit}'),
                const SizedBox(height: 12),

                DropdownButtonFormField<String>(
                  value: _repetitionType,
                  decoration: InputDecoration(
                    labelText: 'Repeat',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  items:
                      [
                        'Daily',
                        'Weekdays',
                        'Custom Dates',
                      ].map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _repetitionType = value);
                      _updateSchedule();
                    }
                  },
                ),

                if (_repetitionType == 'Weekdays') ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children:
                        ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'].map((day) {
                          final isSelected = _selectedWeekdays.contains(day);
                          return FilterChip(
                            label: Text(day),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  _selectedWeekdays.add(day);
                                } else {
                                  _selectedWeekdays.remove(day);
                                }
                              });
                              _updateSchedule();
                            },
                          );
                        }).toList(),
                  ),
                ],

                if (_repetitionType == 'Custom Dates') ...[
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (date != null && !_customDates.contains(date)) {
                        setState(() => _customDates.add(date));
                        _updateSchedule();
                      }
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add Date'),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children:
                        _customDates
                            .map(
                              (date) => Chip(
                                label: Text(DateFormat('MMM d').format(date)),
                                onDeleted: () {
                                  setState(() => _customDates.remove(date));
                                  _updateSchedule();
                                },
                              ),
                            )
                            .toList(),
                  ),
                ],

                const SizedBox(height: 16),
                const Text('Time & Quantity', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),

                Column(
                  children: List.generate(_slots.length, (index) {
                    final slot = _slots[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: InkWell(
                                  onTap: () async {
                                    final pickedTime = await showTimePicker(
                                      context: context,
                                      initialTime: slot.time ?? TimeOfDay.now(),
                                    );
                                    if (pickedTime != null) {
                                      setState(() => slot.time = pickedTime);
                                      _updateSchedule();
                                    }
                                  },
                                  child: InputDecorator(
                                    decoration: const InputDecoration(labelText: 'Time', border: OutlineInputBorder()),
                                    child: Text(
                                      slot.time != null ? slot.time!.format(context) : 'Select time',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: slot.time != null ? Colors.white : Colors.grey.shade500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                flex: 2,
                                child: TextFormField(
                                  controller: slot.quantityController,
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  decoration: const InputDecoration(
                                    labelText: 'Quantity',
                                    border: OutlineInputBorder(),
                                  ),
                                  onChanged: (_) => _updateSchedule(),
                                ),
                              ),
                              const SizedBox(width: 8),
                              if (_slots.length > 1)
                                IconButton(
                                  icon: const Icon(Icons.remove_circle, color: Colors.grey),
                                  onPressed: () {
                                    setState(() => _slots.removeAt(index));
                                    _updateSchedule();
                                  },
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),

                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: () {
                      setState(() => _slots.add(_TimeQuantitySlot()));
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add Slot'),
                  ),
                ),

                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: widget.onRemove,
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    label: const Text('Remove', style: TextStyle(color: Colors.red)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TimeQuantitySlot {
  TimeOfDay? time;
  final TextEditingController quantityController = TextEditingController();
}
