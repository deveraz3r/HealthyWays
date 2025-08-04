import 'package:fpdart/fpdart.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/core/usecase/usecase.dart';
import 'package:healthyways/features/permission_requests/domain/entities/permission_request.dart';
import 'package:healthyways/features/permission_requests/domain/repositories/premission_requests_repo.dart';

class UpdatePermissionStatus
    implements UseCase<void, UpdatePermissionStatusParams> {
  final PermissionRequestRepository repository;

  UpdatePermissionStatus(this.repository);

  @override
  Future<Either<Failure, void>> call(params) {
    return repository.updateRequestStatus(params.requestId, params.status);
  }
}

class UpdatePermissionStatusParams {
  final String requestId;
  final PermissionStatus status;

  UpdatePermissionStatusParams({required this.requestId, required this.status});
}
