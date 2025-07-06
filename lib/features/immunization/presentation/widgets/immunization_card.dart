import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthyways/core/theme/app_pallete.dart';
import 'package:healthyways/features/immunization/domain/entities/immunization.dart';
import 'package:healthyways/features/immunization/presentation/controllers/immunization_controller.dart';
import 'package:healthyways/features/immunization/presentation/widgets/immunization_entry_dialog.dart';
import 'package:intl/intl.dart';

class ImmunizationCard extends StatefulWidget {
  final Immunization immunization;
  const ImmunizationCard({super.key, required this.immunization});

  @override
  State<ImmunizationCard> createState() => _ImmunizationCardState();
}

class _ImmunizationCardState extends State<ImmunizationCard> {
  bool _isExpanded = false;

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => ImmunizationEntryDialog(
            initialTitle: widget.immunization.title,
            initialBody: widget.immunization.body,
            onSubmit: (title, body) async {
              final controller = Get.find<ImmunizationController>();
              await controller.updateImmunizationEntry(id: widget.immunization.id, title: title, body: body);
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
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
        child: ExpansionTile(
          initiallyExpanded: _isExpanded,
          onExpansionChanged: (expanded) {
            setState(() => _isExpanded = expanded);
          },
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Column(
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
                    child: Icon(Icons.vaccines, size: 32, color: AppPallete.gradient1),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.immunization.title,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.edit_calendar, size: 14, color: AppPallete.greyColor),
                            const SizedBox(width: 4),
                            Text(
                              'Updated on ${DateFormat('MMM d, y').format(widget.immunization.lastUpdated)}',
                              style: const TextStyle(fontSize: 14, color: AppPallete.greyColor),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.immunization.body, style: const TextStyle(fontSize: 16, color: AppPallete.greyColor)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        widget.immunization.providerId == null ? Icons.person : Icons.medical_services,
                        size: 14,
                        color: AppPallete.greyColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        widget.immunization.providerId == null ? 'Self Recorded' : 'Provider Recorded',
                        style: const TextStyle(fontSize: 14, color: AppPallete.greyColor),
                      ),
                      const Spacer(),
                      Text(
                        DateFormat('hh:mm a').format(widget.immunization.createdAt),
                        style: const TextStyle(fontSize: 14, color: AppPallete.greyColor),
                      ),
                      if (_isExpanded) ...[
                        const SizedBox(width: 8),
                        TextButton.icon(
                          icon: const Icon(Icons.edit, size: 14),
                          label: const Text("Edit"),
                          style: TextButton.styleFrom(
                            foregroundColor: AppPallete.greyColor,
                            textStyle: const TextStyle(fontSize: 14),
                          ),
                          onPressed: () => _showEditDialog(context),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
