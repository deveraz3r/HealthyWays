import 'package:get/get.dart';
import 'package:healthyways/core/common/controllers/app_profile_controller.dart';
import 'package:healthyways/core/controller/controller_state_manager.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/core/usecase/usecase.dart';
import 'package:healthyways/features/diary/domain/entites/diary.dart';
import 'package:healthyways/features/diary/domain/usecases/create_diary_entry.dart';
import 'package:healthyways/features/diary/domain/usecases/delete_diary_entry.dart';
import 'package:healthyways/features/diary/domain/usecases/get_all_diary_entries.dart';
import 'package:healthyways/features/diary/domain/usecases/update_diary_entry.dart';
import 'package:uuid/uuid.dart';

class DiaryController extends GetxController {
  final AppProfileController _appProfileController;
  final GetAllDiaryEntries _getAllDiaryEntries;
  final CreateDiaryEntry _createDiaryEntry;
  final DeleteDiaryEntry _deleteDiaryEntry;
  final UpdateDiaryEntry _updateDiaryEntry;

  DiaryController({
    required AppProfileController appProfileController,
    required GetAllDiaryEntries getAllDiaryEntries,
    required CreateDiaryEntry createDiaryEntry,
    required DeleteDiaryEntry deleteDiaryEntry,
    required UpdateDiaryEntry updateDiaryEntry,
  }) : _appProfileController = appProfileController,
       _getAllDiaryEntries = getAllDiaryEntries,
       _createDiaryEntry = createDiaryEntry,
       _deleteDiaryEntry = deleteDiaryEntry,
       _updateDiaryEntry = updateDiaryEntry;

  @override
  void onInit() {
    super.onInit();
    getAllDiaryEntries(); //Load Entries as soon as controller is initlized
  }

  final diaryEntries = StateController<Failure, List<Diary>>();

  Future<void> getAllDiaryEntries() async {
    diaryEntries.setLoading();
    final response = await _getAllDiaryEntries(NoParams());

    response.fold((failure) => diaryEntries.setError(failure), (entries) => diaryEntries.setData(entries));
  }

  Future<void> createDiaryEntry({required String title, required String body}) async {
    final Diary diary = Diary(
      id: const Uuid().v4(),
      patientId: _appProfileController.profile.data!.uid,
      providerId: null,
      title: title,
      body: body,
      lastUpdated: DateTime.now(),
      createdAt: DateTime.now(),
    );
    final response = await _createDiaryEntry(CreateDiaryEntryParams(diary: diary));

    response.fold(
      (failure) {
        print('Failed to create diary entry: ${failure.message}');
        Get.snackbar('Error', 'Failed to create diary entry', snackPosition: SnackPosition.BOTTOM);
      },
      (_) {
        final currentList = diaryEntries.data ?? [];
        diaryEntries.setData([...currentList, diary]);

        Get.snackbar('Success', 'Diary entry created successfully', snackPosition: SnackPosition.BOTTOM);
      },
    );
  }

  Future<void> updateDiaryEntry({required String id, required String title, required String body}) async {
    final response = await _updateDiaryEntry(UpdateDiaryEntryParams(id: id, title: title, body: body));

    response.fold(
      (failure) {
        print('Failed to update diary entry: ${failure.message}');
        Get.snackbar('Error', 'Failed to update diary entry', snackPosition: SnackPosition.BOTTOM);
      },
      (success) {
        final currentList = diaryEntries.data ?? [];
        diaryEntries.setData([...currentList, success]);

        Get.snackbar('Success', 'Diary entry updated successfully', snackPosition: SnackPosition.BOTTOM);
      },
    );
  }

  Future<void> deleteDiaryEntry(String id) async {
    final response = await _deleteDiaryEntry(DeleteDiaryEntryParams(id: id));

    response.fold(
      (failure) {
        print('Failed to delete diary entry: ${failure.message}');
        Get.snackbar('Error', 'Failed to delete diary entry', snackPosition: SnackPosition.BOTTOM);
      },
      (success) {
        final currentList = diaryEntries.data ?? [];
        final updatedList = currentList.where((e) => e.id != id).toList();
        diaryEntries.setData(updatedList);

        Get.snackbar('Success', 'Diary entry deleted successfully', snackPosition: SnackPosition.BOTTOM);
      },
    );
  }
}
