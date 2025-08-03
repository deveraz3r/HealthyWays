import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthyways/core/common/controllers/app_profile_controller.dart';
import 'package:healthyways/core/common/widgets/loader.dart';
import 'package:healthyways/core/theme/app_pallete.dart';
import 'package:healthyways/features/diary/domain/entites/diary.dart';
import 'package:healthyways/features/diary/presentation/controllers/diary_controller.dart';
import 'package:healthyways/features/diary/presentation/widgets/diary_card.dart';
import 'package:healthyways/features/diary/presentation/widgets/diary_entry_dialog.dart';

class DiaryHomePage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (_) => const DiaryHomePage());
  const DiaryHomePage({super.key});

  @override
  State<DiaryHomePage> createState() => _DiaryHomePageState();
}

class _DiaryHomePageState extends State<DiaryHomePage> {
  final DiaryController _diaryController = Get.find();

  @override
  void initState() {
    super.initState();

    final currentUser = Get.find<AppProfileController>().profile.data!;
    final isPatient = currentUser.selectedRole.name == 'patient';

    if (isPatient) {
      _diaryController.patientId.value = currentUser.uid;
      _diaryController.getAllDiaryEntries();
    }
    // For provider roles, call checkDiaryAccess(patientProfile) from parent
  }

  void _showAddDiaryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => DiaryEntryDialog(
            onSubmit: (title, body) async {
              await _diaryController.createDiaryEntry(title: title, body: body);
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = Get.find<AppProfileController>().profile.data!;
    final isPatient = currentUser.selectedRole.name == 'patient';

    return Scaffold(
      appBar: AppBar(
        title: const Text("Diary"),
        backgroundColor: AppPallete.backgroundColor2,
        actions: [
          Obx(() {
            final access = _diaryController.diaryAccess.value;
            if (isPatient || (access != null && access.isAllowed)) {
              return IconButton(
                icon: const Icon(CupertinoIcons.add_circled_solid),
                onPressed: () => _showAddDiaryDialog(context),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Obx(() {
          final access = _diaryController.diaryAccess.value;

          if (!isPatient && access == null) {
            return const Center(child: Text("Access verification pending..."));
          }

          if (!isPatient && access != null && !access.isAllowed) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.lock_outline, size: 48, color: Colors.grey),
                  const SizedBox(height: 12),
                  Text(
                    access.message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Get.snackbar(
                        "Access Request",
                        "Your request has been sent to the patient.",
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                    child: const Text("Request Access"),
                  ),
                ],
              ),
            );
          }

          if (_diaryController.diaryEntries.isLoading) {
            return const Loader();
          }

          if (_diaryController.diaryEntries.hasError) {
            return Center(
              child: Text(_diaryController.diaryEntries.error!.message),
            );
          }

          if (_diaryController.diaryEntries.hasData &&
              _diaryController.diaryEntries.data!.isEmpty) {
            return Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "No Diary Entries yet, ",
                    style: TextStyle(fontSize: 18),
                  ),
                  InkWell(
                    onTap:
                        () async => await _diaryController.getAllDiaryEntries(),
                    child: Text(
                      "retry",
                      style: TextStyle(
                        fontSize: 18,
                        color: AppPallete.gradient1,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            itemCount: _diaryController.diaryEntries.rxData.value!.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              Diary diary = _diaryController.diaryEntries.rxData.value![index];
              return DiaryCard(diary: diary);
            },
          );
        }),
      ),
    );
  }
}
