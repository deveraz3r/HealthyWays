import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthyways/core/theme/app_pallete.dart';

class PatientSettingsPage extends StatelessWidget {
  static route() => MaterialPageRoute(builder: (context) => const PatientSettingsPage());
  const PatientSettingsPage({super.key});

  void _showLanguagePicker(BuildContext context) {
    final Map<String, String> languageMap = {
      'en': 'English',
      'es': 'Spanish',
      'fr': 'French',
      'de': 'German',
      'other': 'Other',
    };

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(16),
          children:
              languageMap.entries.map((entry) {
                return ListTile(
                  leading: const Icon(Icons.language),
                  title: Text(entry.value),
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Save language preference (via controller or local storage)
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('Language changed to ${entry.value}')));
                  },
                );
              }).toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> settingsItems = [
      {'title': 'Preferred Language', 'icon': Icons.language, 'onTap': () => _showLanguagePicker(context)},
      {
        'title': 'Notifications',
        'icon': CupertinoIcons.bell,
        'onTap': () {
          print("Notifications tapped");
        },
      },
      {
        'title': 'Password & Security',
        'icon': Icons.password,
        'onTap': () {
          print("Adjust diaries visibility tapped");
        },
      },
      {
        'title': 'Logout',
        'icon': Icons.logout,
        'onTap': () {
          print("Logout tapped");
        },
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back)),
        backgroundColor: AppPallete.backgroundColor2,
      ),
      body: ListView.separated(
        itemCount: settingsItems.length,
        separatorBuilder:
            (context, index) => Divider(color: AppPallete.greyColor.withOpacity(0.3), thickness: 0.5, height: 1),
        itemBuilder: (context, index) {
          final item = settingsItems[index];
          return ListTile(
            leading: Icon(item['icon'], color: AppPallete.gradient1),
            title: Text(item['title'], style: const TextStyle(fontSize: 16)),
            onTap: item['onTap'],
          );
        },
      ),
    );
  }
}
