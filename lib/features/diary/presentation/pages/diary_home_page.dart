import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthyways/core/common/widgets/loader.dart';
import 'package:healthyways/core/theme/app_pallete.dart';
import 'package:healthyways/features/diary/domain/entites/diary.dart';
import 'package:healthyways/features/diary/presentation/controllers/diary_controller.dart';
import 'package:healthyways/features/diary/presentation/widgets/diary_card.dart';
import 'package:healthyways/features/diary/presentation/widgets/diary_entry_dialog.dart';

class DiaryHomePage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (_) => DiaryHomePage());
  const DiaryHomePage({super.key});

  @override
  State<DiaryHomePage> createState() => _DiaryHomePageState();
}

class _DiaryHomePageState extends State<DiaryHomePage> {
  final DiaryController _diaryController = Get.find();

  @override
  void initState() {
    // _diaryController.getAllDiaryEntries();
    super.initState();
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Diary"),
        backgroundColor: AppPallete.backgroundColor2,
        actions: [
          IconButton(icon: Icon(CupertinoIcons.add_circled_solid), onPressed: () => _showAddDiaryDialog(context)),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Obx(() {
          if (_diaryController.diaryEntries.isLoading) {
            return Loader();
          }

          if (_diaryController.diaryEntries.hasError) {
            return Center(child: Text(_diaryController.diaryEntries.error!.message));
          }

          if (_diaryController.diaryEntries.hasData && _diaryController.diaryEntries.data!.isEmpty) {
            return Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("No Diary Entries yet, ", style: TextStyle(fontSize: 18)),
                  InkWell(
                    onTap: () async => await _diaryController.getAllDiaryEntries(),
                    child: Text("retry", style: TextStyle(fontSize: 18, color: AppPallete.gradient1)),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            itemCount: _diaryController.diaryEntries.rxData.value!.length,
            separatorBuilder: (context, index) => SizedBox(height: 10),
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
