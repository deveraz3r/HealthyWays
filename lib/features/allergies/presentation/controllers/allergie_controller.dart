import 'package:get/get.dart';
import 'package:healthyways/core/common/controllers/app_profile_controller.dart';
import 'package:healthyways/core/controller/controller_state_manager.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/core/usecase/usecase.dart';
import 'package:healthyways/features/allergies/domain/entities/allergy.dart';
import 'package:healthyways/features/allergies/domain/usecases/create_allergie_entry.dart';
import 'package:healthyways/features/allergies/domain/usecases/delete_allergie_entry.dart';
import 'package:healthyways/features/allergies/domain/usecases/get_all_allergie_entries.dart';
import 'package:healthyways/features/allergies/domain/usecases/update_allergie_entry.dart';
import 'package:uuid/uuid.dart';

class AllergiesController extends GetxController {
  final AppProfileController _appProfileController;
  final GetAllAllergyEntries _getAllAllergieEntries;
  final CreateAllergyEntry _createAllergieEntry;
  final DeleteAllergyEntry _deleteAllergieEntry;
  final UpdateAllergyEntry _updateAllergieEntry;

  AllergiesController({
    required AppProfileController appProfileController,
    required GetAllAllergyEntries getAllAllergieEntries,
    required CreateAllergyEntry createAllergieEntry,
    required DeleteAllergyEntry deleteAllergieEntry,
    required UpdateAllergyEntry updateAllergieEntry,
  }) : _appProfileController = appProfileController,
       _getAllAllergieEntries = getAllAllergieEntries,
       _createAllergieEntry = createAllergieEntry,
       _deleteAllergieEntry = deleteAllergieEntry,
       _updateAllergieEntry = updateAllergieEntry;

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration(milliseconds: 100), () {
      getAllAllergieEntries();
    });
  }

  final allergieEntries = StateController<Failure, List<Allergy>>();

  Future<void> getAllAllergieEntries() async {
    if (allergieEntries.isLoading) return;

    allergieEntries.setLoading();
    final response = await _getAllAllergieEntries(NoParams());

    response.fold((failure) => allergieEntries.setError(failure), (entries) => allergieEntries.setData(entries));
  }

  Future<void> createAllergieEntry({required String title, required String body}) async {
    final allergie = Allergy(
      id: const Uuid().v4(),
      patientId: _appProfileController.profile.data!.uid,
      providerId: null,
      title: title,
      body: body,
      lastUpdated: DateTime.now(),
      createdAt: DateTime.now(),
    );

    final response = await _createAllergieEntry(CreateAllergieEntryParams(allergie: allergie));

    response.fold(
      (failure) {
        print('Failed to create allergie entry: ${failure.message}');
        Get.snackbar('Error', 'Failed to create allergie entry', snackPosition: SnackPosition.BOTTOM);
      },
      (_) {
        final currentList = allergieEntries.data ?? [];
        allergieEntries.setData([...currentList, allergie]);
        Get.snackbar('Success', 'Allergie entry created successfully', snackPosition: SnackPosition.BOTTOM);
      },
    );
  }

  Future<void> updateAllergieEntry({required String id, required String title, required String body}) async {
    final response = await _updateAllergieEntry(UpdateAllergieEntryParams(id: id, title: title, body: body));

    response.fold(
      (failure) {
        print('Failed to update allergie entry: ${failure.message}');
        Get.snackbar('Error', 'Failed to update allergie entry', snackPosition: SnackPosition.BOTTOM);
      },
      (updatedAllergie) {
        final currentList = allergieEntries.data ?? [];
        final updatedList =
            currentList.map((entry) {
              return entry.id == id ? updatedAllergie : entry;
            }).toList();

        allergieEntries.setData(updatedList);
        Get.snackbar('Success', 'Allergie entry updated successfully', snackPosition: SnackPosition.BOTTOM);
      },
    );
  }

  Future<void> deleteAllergieEntry(String id) async {
    final response = await _deleteAllergieEntry(DeleteAllergieEntryParams(id: id));

    response.fold(
      (failure) {
        print('Failed to delete allergie entry: ${failure.message}');
        Get.snackbar('Error', 'Failed to delete allergie entry', snackPosition: SnackPosition.BOTTOM);
      },
      (_) {
        final currentList = allergieEntries.data ?? [];
        final updatedList = currentList.where((e) => e.id != id).toList();
        allergieEntries.setData(updatedList);
        Get.snackbar('Success', 'Allergie entry deleted successfully', snackPosition: SnackPosition.BOTTOM);
      },
    );
  }
}
