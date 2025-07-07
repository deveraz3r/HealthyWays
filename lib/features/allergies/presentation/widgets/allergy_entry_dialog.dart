import 'package:flutter/material.dart';
import 'package:healthyways/core/theme/app_pallete.dart';

class AllergyEntryDialog extends StatelessWidget {
  final String? initialTitle;
  final String? initialBody;
  final void Function(String title, String body) onSubmit;

  const AllergyEntryDialog({super.key, this.initialTitle, this.initialBody, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController(text: initialTitle);
    final bodyController = TextEditingController(text: initialBody);

    return AlertDialog(
      backgroundColor: AppPallete.backgroundColor2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        initialTitle == null ? 'New Allergy Entry' : 'Edit Allergy Entry',
        style: const TextStyle(color: Colors.white),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(labelText: 'Allergy Name', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: bodyController,
            decoration: const InputDecoration(labelText: 'Notes', border: OutlineInputBorder()),
            maxLines: 4,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(color: Colors.white)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppPallete.gradient1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: () {
            final title = titleController.text.trim();
            final body = bodyController.text.trim();

            if (title.isEmpty || body.isEmpty) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Allergy name and notes cannot be empty')));
              return;
            }

            onSubmit(title, body);
            Navigator.pop(context);
          },
          child: Text(initialTitle == null ? 'Add' : 'Update'),
        ),
      ],
    );
  }
}
