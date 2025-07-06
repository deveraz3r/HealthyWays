import 'package:get/get.dart';
import 'package:healthyways/core/common/controllers/app_profile_controller.dart';
import 'package:healthyways/core/controller/controller_state_manager.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/core/usecase/usecase.dart';
import 'package:healthyways/features/immunization/domain/entities/immunization.dart';
import 'package:healthyways/features/immunization/domain/usecases/create_immunization_entry.dart';
import 'package:healthyways/features/immunization/domain/usecases/delete_immunization_entry.dart';
import 'package:healthyways/features/immunization/domain/usecases/get_all_immunization_entries.dart';
import 'package:healthyways/features/immunization/domain/usecases/update_immunization_entry.dart';
import 'package:uuid/uuid.dart';

class ImmunizationController extends GetxController {
  final AppProfileController _appProfileController;
  final GetAllImmunizationEntries _getAllImmunizationEntries;
  final CreateImmunizationEntry _createImmunizationEntry;
  final DeleteImmunizationEntry _deleteImmunizationEntry;
  final UpdateImmunizationEntry _updateImmunizationEntry;

  ImmunizationController({
    required AppProfileController appProfileController,
    required GetAllImmunizationEntries getAllImmunizationEntries,
    required CreateImmunizationEntry createImmunizationEntry,
    required DeleteImmunizationEntry deleteImmunizationEntry,
    required UpdateImmunizationEntry updateImmunizationEntry,
  }) : _appProfileController = appProfileController,
       _getAllImmunizationEntries = getAllImmunizationEntries,
       _createImmunizationEntry = createImmunizationEntry,
       _deleteImmunizationEntry = deleteImmunizationEntry,
       _updateImmunizationEntry = updateImmunizationEntry;

  @override
  void onInit() {
    super.onInit();
    // getAllImmunizationEntries(); //Load Entries as soon as controller is initialized
    Future.delayed(Duration(milliseconds: 100), () {
      getAllImmunizationEntries();
    });
  }

  final immunizationEntries = StateController<Failure, List<Immunization>>();

  Future<void> getAllImmunizationEntries() async {
    if (immunizationEntries.isLoading) return; // Prevent multiple simultaneous loads

    immunizationEntries.setLoading();
    final response = await _getAllImmunizationEntries(NoParams());

    response.fold(
      (failure) => immunizationEntries.setError(failure),
      (entries) => immunizationEntries.setData(entries),
    );
  }

  Future<void> createImmunizationEntry({required String title, required String body}) async {
    final immunization = Immunization(
      id: const Uuid().v4(),
      patientId: _appProfileController.profile.data!.uid,
      providerId: null,
      title: title,
      body: body,
      lastUpdated: DateTime.now(),
      createdAt: DateTime.now(),
    );

    final response = await _createImmunizationEntry(CreateImmunizationEntryParams(immunization: immunization));

    response.fold(
      (failure) {
        print('Failed to create immunization entry: ${failure.message}');
        Get.snackbar('Error', 'Failed to create immunization entry', snackPosition: SnackPosition.BOTTOM);
      },
      (_) {
        final currentList = immunizationEntries.data ?? [];
        immunizationEntries.setData([...currentList, immunization]);
        Get.snackbar('Success', 'Immunization entry created successfully', snackPosition: SnackPosition.BOTTOM);
      },
    );
  }

  Future<void> updateImmunizationEntry({required String id, required String title, required String body}) async {
    final response = await _updateImmunizationEntry(UpdateImmunizationEntryParams(id: id, title: title, body: body));

    response.fold(
      (failure) {
        print('Failed to update immunization entry: ${failure.message}');
        Get.snackbar('Error', 'Failed to update immunization entry', snackPosition: SnackPosition.BOTTOM);
      },
      (updatedImmunization) {
        final currentList = immunizationEntries.data ?? [];
        final updatedList =
            currentList.map((entry) {
              return entry.id == id ? updatedImmunization : entry;
            }).toList();

        immunizationEntries.setData(updatedList);
        Get.snackbar('Success', 'Immunization entry updated successfully', snackPosition: SnackPosition.BOTTOM);
      },
    );
  }

  Future<void> deleteImmunizationEntry(String id) async {
    final response = await _deleteImmunizationEntry(DeleteImmunizationEntryParams(id: id));

    response.fold(
      (failure) {
        print('Failed to delete immunization entry: ${failure.message}');
        Get.snackbar('Error', 'Failed to delete immunization entry', snackPosition: SnackPosition.BOTTOM);
      },
      (_) {
        final currentList = immunizationEntries.data ?? [];
        final updatedList = currentList.where((e) => e.id != id).toList();
        immunizationEntries.setData(updatedList);
        Get.snackbar('Success', 'Immunization entry deleted successfully', snackPosition: SnackPosition.BOTTOM);
      },
    );
  }
}
