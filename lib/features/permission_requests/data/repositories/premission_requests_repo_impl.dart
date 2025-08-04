import 'package:fpdart/fpdart.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/core/common/custom_types/role.dart';
import 'package:healthyways/features/permission_requests/data/datasources/permission_requests_remote_datasource.dart';
import 'package:healthyways/features/permission_requests/data/models/permission_request_model.dart';
import 'package:healthyways/features/permission_requests/domain/entities/permission_request.dart';
import 'package:healthyways/features/permission_requests/domain/repositories/premission_requests_repo.dart';

class PermissionRequestRepositoryImpl implements PermissionRequestRepository {
  final PermissionRequestRemoteDataSource remoteDataSource;

  PermissionRequestRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, void>> createPermissionRequest(
    PermissionRequest request,
  ) async {
    try {
      final model = PermissionRequestModel.fromPermissionRequest(request);
      await remoteDataSource.createPermissionRequest(model);
      return right(null);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PermissionRequest>>> getIncomingRequests(
    String userId,
    Role role,
  ) async {
    try {
      final list = await remoteDataSource.getIncomingRequests(userId, role);
      return right(list);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PermissionRequest>>> getOutgoingRequests(
    String userId,
    Role role,
  ) async {
    try {
      final list = await remoteDataSource.getOutgoingRequests(userId, role);
      return right(list);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateRequestStatus(
    String requestId,
    PermissionStatus status,
  ) async {
    try {
      await remoteDataSource.updateRequestStatus(
        requestId: requestId,
        status: status,
      );
      return right(null);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteRequest(String requestId) async {
    try {
      await remoteDataSource.deleteRequest(requestId);
      return right(null);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
