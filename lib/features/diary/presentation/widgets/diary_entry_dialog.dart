import 'package:flutter/material.dart';
import 'package:healthyways/core/theme/app_pallete.dart';

class DiaryEntryDialog extends StatelessWidget {
  final String? initialTitle;
  final String? initialBody;
  final void Function(String title, String body) onSubmit;

  const DiaryEntryDialog({super.key, this.initialTitle, this.initialBody, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController(text: initialTitle);
    final bodyController = TextEditingController(text: initialBody);

    return AlertDialog(
      title: Text(initialTitle == null ? 'New Diary Entry' : 'Edit Diary Entry'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Title')),
          const SizedBox(height: 10),
          TextField(controller: bodyController, decoration: const InputDecoration(labelText: 'Body'), maxLines: 4),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            final title = titleController.text.trim();
            final body = bodyController.text.trim();

            if (title.isEmpty || body.isEmpty) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Title and Body cannot be empty')));
              return;
            }

            Navigator.pop(context);
            onSubmit(title, body);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
