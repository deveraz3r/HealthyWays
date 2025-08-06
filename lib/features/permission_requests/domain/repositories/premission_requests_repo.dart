import 'package:fpdart/fpdart.dart';
import 'package:healthyways/core/common/entites/profile.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/core/common/custom_types/role.dart';
import 'package:healthyways/features/permission_requests/domain/entities/permission_request.dart';

abstract class PermissionRequestRepository {
  Future<Either<Failure, void>> createPermissionRequest(
    PermissionRequest request,
  );
  Future<Either<Failure, List<PermissionRequest>>> getIncomingRequests(
    String userId,
    Role role,
  );
  Future<Either<Failure, List<PermissionRequest>>> getOutgoingRequests(
    String userId,
    Role role,
  );
  Future<Either<Failure, void>> updateRequestStatus(
    String requestId,
    PermissionStatus status,
  );
  Future<Either<Failure, void>> deleteRequest(String requestId);

  Future<Either<Failure, Profile>> getProfileDataById(String uid);
  Future<Either<Failure, void>> addProviderId({
    required String providerId,
    required String patientId,
  });
}
