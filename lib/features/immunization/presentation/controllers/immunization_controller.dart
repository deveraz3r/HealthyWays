import 'package:get/get.dart';
import 'package:healthyways/core/common/controllers/app_profile_controller.dart';
import 'package:healthyways/core/common/custom_types/access_result.dart';
import 'package:healthyways/core/common/custom_types/role.dart';
import 'package:healthyways/core/common/entites/patient_profile.dart';
import 'package:healthyways/core/controller/controller_state_manager.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/core/utils/can_provider_access_feature.dart';
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

  // Set this manually to the user whose data you want to get
  // If user role == patient then it is auto set
  RxString patientId = ''.obs;

  Rx<AccessResult?> immunizationAccess = Rx<AccessResult?>(null);

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
    // Uncomment if you want to auto set for patient
    // if (_appProfileController.profile.data!.selectedRole == Role.patient) {
    //   patientId.value = _appProfileController.profile.data!.uid;
    //   Future.delayed(Duration(milliseconds: 100), () {
    //     getAllImmunizationEntries();
    //   });
    // }
  }

  final immunizationEntries = StateController<Failure, List<Immunization>>();

  Future<void> getAllImmunizationEntries() async {
    if (immunizationEntries.isLoading) return;

    immunizationEntries.setLoading();
    final response = await _getAllImmunizationEntries(
      GetAllImmunizationEntriesParams(uid: patientId.value),
    );

    response.fold(
      (failure) => immunizationEntries.setError(failure),
      (entries) => immunizationEntries.setData(entries),
    );
  }

  Future<void> createImmunizationEntry({
    required String title,
    required String body,
  }) async {
    String currentUserId = _appProfileController.profile.data!.uid;

    final immunization = Immunization(
      id: const Uuid().v4(),
      patientId: patientId.value,
      providerId: currentUserId == patientId.value ? null : currentUserId,
      title: title,
      body: body,
      lastUpdated: DateTime.now(),
      createdAt: DateTime.now(),
    );

    final response = await _createImmunizationEntry(
      CreateImmunizationEntryParams(immunization: immunization),
    );

    response.fold(
      (failure) {
        Get.snackbar(
          'Error',
          'Failed to create immunization entry',
          snackPosition: SnackPosition.BOTTOM,
        );
      },
      (_) {
        final currentList = immunizationEntries.data ?? [];
        immunizationEntries.setData([...currentList, immunization]);
        Get.snackbar(
          'Success',
          'Immunization entry created successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      },
    );
  }

  Future<void> updateImmunizationEntry({
    required String id,
    required String title,
    required String body,
  }) async {
    String currentUserId = _appProfileController.profile.data!.uid;

    final response = await _updateImmunizationEntry(
      UpdateImmunizationEntryParams(
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
          'Failed to update immunization entry',
          snackPosition: SnackPosition.BOTTOM,
        );
      },
      (updatedImmunization) {
        final currentList = immunizationEntries.data ?? [];
        final updatedList =
            currentList.map((entry) {
              return entry.id == id ? updatedImmunization : entry;
            }).toList();

        immunizationEntries.setData(updatedList);
        Get.snackbar(
          'Success',
          'Immunization entry updated successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      },
    );
  }

  Future<void> deleteImmunizationEntry(String id) async {
    final response = await _deleteImmunizationEntry(
      DeleteImmunizationEntryParams(id: id),
    );

    response.fold(
      (failure) {
        Get.snackbar(
          'Error',
          'Failed to delete immunization entry',
          snackPosition: SnackPosition.BOTTOM,
        );
      },
      (_) {
        final currentList = immunizationEntries.data ?? [];
        final updatedList = currentList.where((e) => e.id != id).toList();
        immunizationEntries.setData(updatedList);
        Get.snackbar(
          'Success',
          'Immunization entry deleted successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      },
    );
  }

  /// Checks access based on current profile and patient profile
  void checkImmunizationAccess(PatientProfile patientProfile) {
    immunizationEntries.setLoading();
    final currentUser = _appProfileController.profile.data!;

    if (currentUser.selectedRole == Role.doctor ||
        currentUser.selectedRole == Role.pharmacist) {
      final access = canProviderAccessFeature(
        patient: patientProfile,
        providerId: currentUser.uid,
        featureVisibility: patientProfile.immunizationsVisibility,
      );

      immunizationAccess.value = access;

      if (access.isAllowed) {
        patientId.value = patientProfile.uid;
        getAllImmunizationEntries();
      }
    } else if (currentUser.selectedRole == Role.patient) {
      // Patient always has access to own data
      patientId.value = currentUser.uid;
      getAllImmunizationEntries();
    }
  }
}
