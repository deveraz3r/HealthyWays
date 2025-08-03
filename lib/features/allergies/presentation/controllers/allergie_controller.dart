import 'package:get/get.dart';
import 'package:healthyways/core/common/controllers/app_profile_controller.dart';
import 'package:healthyways/core/common/custom_types/access_result.dart';
import 'package:healthyways/core/common/custom_types/role.dart';
import 'package:healthyways/core/common/entites/patient_profile.dart';
import 'package:healthyways/core/controller/controller_state_manager.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/core/utils/can_provider_access_feature.dart';
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

  RxString patientId = ''.obs;
  final allergieEntries = StateController<Failure, List<Allergy>>();
  Rx<AccessResult?> allergieAccess = Rx<AccessResult?>(null);

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

  Future<void> getAllAllergieEntries() async {
    if (allergieEntries.isLoading) return;

    allergieEntries.setLoading();
    final response = await _getAllAllergieEntries(
      GetAllAllergyEntriesParams(uid: patientId.value),
    );

    response.fold(
      (failure) => allergieEntries.setError(failure),
      (entries) => allergieEntries.setData(entries),
    );
  }

  Future<void> createAllergieEntry({
    required String title,
    required String body,
  }) async {
    String currentUserId = _appProfileController.profile.data!.uid;

    final allergie = Allergy(
      id: const Uuid().v4(),
      patientId: patientId.value,
      providerId: currentUserId == patientId.value ? null : currentUserId,
      title: title,
      body: body,
      lastUpdated: DateTime.now(),
      createdAt: DateTime.now(),
    );

    final response = await _createAllergieEntry(
      CreateAllergieEntryParams(allergie: allergie),
    );

    response.fold(
      (failure) {
        Get.snackbar(
          'Error',
          'Failed to create allergy entry',
          snackPosition: SnackPosition.BOTTOM,
        );
      },
      (_) {
        final currentList = allergieEntries.data ?? [];
        allergieEntries.setData([...currentList, allergie]);
        Get.snackbar(
          'Success',
          'Allergy entry created successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      },
    );
  }

  Future<void> updateAllergieEntry({
    required String id,
    required String title,
    required String body,
  }) async {
    String currentUserId = _appProfileController.profile.data!.uid;

    final response = await _updateAllergieEntry(
      UpdateAllergieEntryParams(
        id: id,
        title: title,
        body: body,
        providerId: currentUserId == patientId.value ? null : currentUserId,
      ),
    );

    response.fold(
      (failure) {
        Get.snackbar(
          'Error',
          'Failed to update allergy entry',
          snackPosition: SnackPosition.BOTTOM,
        );
      },
      (updatedAllergy) {
        final currentList = allergieEntries.data ?? [];
        final updatedList =
            currentList
                .map((entry) => entry.id == id ? updatedAllergy : entry)
                .toList();

        allergieEntries.setData(updatedList);
        Get.snackbar(
          'Success',
          'Allergy entry updated successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      },
    );
  }

  Future<void> deleteAllergieEntry(String id) async {
    final response = await _deleteAllergieEntry(
      DeleteAllergieEntryParams(id: id),
    );

    response.fold(
      (failure) {
        Get.snackbar(
          'Error',
          'Failed to delete allergy entry',
          snackPosition: SnackPosition.BOTTOM,
        );
      },
      (_) {
        final currentList = allergieEntries.data ?? [];
        final updatedList = currentList.where((e) => e.id != id).toList();
        allergieEntries.setData(updatedList);
        Get.snackbar(
          'Success',
          'Allergy entry deleted successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      },
    );
  }

  /// Checks access based on current profile and patient profile
  void checkAllergyAccess(PatientProfile patientProfile) {
    final currentUser = _appProfileController.profile.data!;

    if (currentUser.selectedRole == Role.doctor ||
        currentUser.selectedRole == Role.pharmacist) {
      final access = canProviderAccessFeature(
        patient: patientProfile,
        providerId: currentUser.uid,
        featureVisibility: patientProfile.allergiesVisibility,
      );

      allergieAccess.value = access;

      if (access.isAllowed) {
        patientId.value = patientProfile.uid;
        getAllAllergieEntries();
      }
    } else if (currentUser.selectedRole == Role.patient) {
      patientId.value = currentUser.uid;
      getAllAllergieEntries();
    }
  }
}
