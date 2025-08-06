import 'package:get/get.dart';
import 'package:healthyways/features/permission_requests/domain/usecases/add_provider_id.dart';
import 'package:healthyways/features/permission_requests/domain/usecases/create_premission_request.dart';
import 'package:healthyways/features/permission_requests/domain/usecases/delete_permission_request.dart';
import 'package:healthyways/features/permission_requests/domain/usecases/get_profile_data_by_id.dart';
import 'package:uuid/uuid.dart';
import 'package:healthyways/core/common/custom_types/role.dart';
import 'package:healthyways/core/controller/controller_state_manager.dart';
import 'package:healthyways/core/common/controllers/app_profile_controller.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/features/permission_requests/domain/entities/permission_request.dart';
import 'package:healthyways/features/permission_requests/domain/usecases/get_incoming_permission_requests.dart';
import 'package:healthyways/features/permission_requests/domain/usecases/get_outgoing_permission_requests.dart';
import 'package:healthyways/features/permission_requests/domain/usecases/update_permission_status.dart';

class PermissionRequestController extends GetxController {
  final AppProfileController _appProfileController;
  final CreatePermissionRequest _createPermissionRequest;
  final GetIncomingPermissionRequests _getIncomingPermissionRequests;
  final GetOutgoingPermissionRequests _getOutgoingPermissionRequests;
  final UpdatePermissionStatus _updatePermissionStatus;
  final GetProfileDataById _getProfileDataById;
  final DeletePermissionRequest _deletePermissionRequest;
  final AddProviderId _addProviderId;

  // @override
  // onInit() {
  //   super.onInit();
  //   fetchIncomingRequests();
  //   fetchOutgoingRequests();
  // }

  PermissionRequestController({
    required AppProfileController appProfileController,
    required CreatePermissionRequest createPermissionRequest,
    required GetIncomingPermissionRequests getIncomingPermissionRequests,
    required GetOutgoingPermissionRequests getOutgoingPermissionRequests,
    required UpdatePermissionStatus updatePermissionStatus,
    required GetProfileDataById getProfileDataById,
    required DeletePermissionRequest deletePermissionRequest,
    required AddProviderId addProviderToPatient,
  }) : _appProfileController = appProfileController,
       _createPermissionRequest = createPermissionRequest,
       _getIncomingPermissionRequests = getIncomingPermissionRequests,
       _getOutgoingPermissionRequests = getOutgoingPermissionRequests,
       _getProfileDataById = getProfileDataById,
       _deletePermissionRequest = deletePermissionRequest,
       _addProviderId = addProviderToPatient,
       _updatePermissionStatus = updatePermissionStatus;

  final incomingRequests = StateController<Failure, List<PermissionRequest>>();
  final outgoingRequests = StateController<Failure, List<PermissionRequest>>();

  Future<void> fetchIncomingRequests() async {
    final profile = _appProfileController.profile.data!;
    incomingRequests.setLoading();

    final result = await _getIncomingPermissionRequests(
      GetPermissionRequestsParams(
        userId: profile.uid,
        role: profile.selectedRole,
      ),
    );

    result.fold(
      (failure) => incomingRequests.setError(failure),
      (requests) => incomingRequests.setData(requests),
    );
  }

  Future<void> fetchOutgoingRequests() async {
    final profile = _appProfileController.profile.data!;
    outgoingRequests.setLoading();

    final result = await _getOutgoingPermissionRequests(
      GetPermissionRequestsParams(
        userId: profile.uid,
        role: profile.selectedRole,
      ),
    );

    result.fold(
      (failure) => outgoingRequests.setError(failure),
      (requests) => outgoingRequests.setData(requests),
    );
  }

  Future<void> createRequest({
    required String patientId,
    required String providerId,
    required Role createdByRole,
  }) async {
    final request = PermissionRequest(
      id: const Uuid().v4(),
      patientId: patientId,
      providerId: providerId,
      status: PermissionStatus.pending,
      requestedAt: DateTime.now(),
      createdByRole: createdByRole.name,
    );

    final result = await _createPermissionRequest(
      CreatePermissionRequestParams(request: request),
    );

    result.fold((failure) => Get.snackbar('Error', failure.message), (_) {
      Get.snackbar('Success', 'Permission request sent');
      fetchOutgoingRequests();
    });
  }

  Future<void> updateRequestStatus(
    PermissionRequest request,
    PermissionStatus status,
  ) async {
    final result = await _updatePermissionStatus(
      UpdatePermissionStatusParams(requestId: request.id, status: status),
    );

    result.fold((failure) => Get.snackbar('Error', failure.message), (_) {
      Get.snackbar('Updated', 'Request status updated');
      fetchIncomingRequests();
    });

    if (status == PermissionStatus.accepted) {
      final addProviderResult = await _addProviderId(
        AddProviderIdParams(
          providerId: request.providerId,
          patientId: request.patientId,
        ),
      );

      addProviderResult.fold(
        (failure) => Get.snackbar('Error', failure.message),
        (_) => Get.snackbar('Success', 'Provider added to patient'),
      );
    }
  }

  Future<void> deletePermissionRequest(String requestId) async {
    final result = await _deletePermissionRequest(
      DeletePermissionRequestParams(requestId: requestId),
    );

    result.fold((failure) => Get.snackbar('Error', failure.message), (_) {
      Get.snackbar('Updated', 'Request successfully deleted');
      fetchOutgoingRequests();
    });
  }

  Future<String> getEmailById(String userId) async {
    final result = await _getProfileDataById(
      GetProfileDataByIdParams(uid: userId),
    );
    return result.fold((failure) {
      print('Error fetching email for user $userId: ${failure.message}');
      return 'Unknown';
    }, (profile) => profile.email);
  }

  Future<String> getNameById(String userId) async {
    final result = await _getProfileDataById(
      GetProfileDataByIdParams(uid: userId),
    );
    return result.fold((failure) {
      print('Error fetching email for user $userId: ${failure.message}');
      return 'Unknown';
    }, (profile) => '${profile.fName} ${profile.lName}');
  }
}
