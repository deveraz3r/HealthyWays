import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthyways/core/theme/app_pallete.dart';
import 'package:healthyways/features/diary/domain/entites/diary.dart';
import 'package:healthyways/features/diary/presentation/controllers/diary_controller.dart';
import 'package:healthyways/features/diary/presentation/widgets/diary_entry_dialog.dart';
import 'package:intl/intl.dart';

class DiaryCard extends StatefulWidget {
  final Diary diary;
  const DiaryCard({super.key, required this.diary});

  @override
  State<DiaryCard> createState() => _DiaryCardState();
}

class _DiaryCardState extends State<DiaryCard> {
  bool _isExpanded = false;

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => DiaryEntryDialog(
            initialTitle: widget.diary.title,
            initialBody: widget.diary.body,
            onSubmit: (title, body) async {
              final controller = Get.find<DiaryController>();
              await controller.updateDiaryEntry(id: widget.diary.id, title: title, body: body);
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
            setState(() {
              _isExpanded = expanded;
            });
          },
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Container(
                  //   width: 48,
                  //   height: 48,
                  //   decoration: BoxDecoration(
                  //     color: AppPallete.backgroundColor2,
                  //     borderRadius: BorderRadius.circular(12),
                  //   ),
                  //   child: Icon(
                  //     widget.diary.providerId == null ? Icons.person_outline : Icons.medical_services_outlined,
                  //     size: 32,
                  //     color: AppPallete.gradient1,
                  //   ),
                  // ),
                  // const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.diary.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.edit, size: 14, color: AppPallete.greyColor),
                            const SizedBox(width: 4),
                            Text(
                              'Last edited ${DateFormat('MMM d, y, hh:mm').format(widget.diary.lastUpdated)}',
                              style: const TextStyle(fontSize: 14, color: AppPallete.greyColor),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.diary.body, style: const TextStyle(fontSize: 16, color: AppPallete.greyColor)),
                  Row(
                    children: [
                      Icon(
                        widget.diary.providerId == null ? Icons.person : Icons.medical_services,
                        size: 14,
                        color: AppPallete.greyColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        widget.diary.providerId == null ? 'Self Entry' : 'Provider Entry',
                        style: const TextStyle(fontSize: 14, color: AppPallete.greyColor),
                      ),
                      Spacer(),
                      if (_isExpanded)
                        TextButton(
                          child: Text("edit", style: TextStyle(fontSize: 14, color: AppPallete.greyColor)),
                          onPressed: () => _showEditDialog(context),
                        ),
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
