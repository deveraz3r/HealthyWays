import 'package:fpdart/fpdart.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/core/usecase/usecase.dart';
import 'package:healthyways/features/permission_requests/domain/repositories/premission_requests_repo.dart';

class DeletePermissionRequest
    implements UseCase<void, DeletePermissionRequestParams> {
  final PermissionRequestRepository repository;

  DeletePermissionRequest(this.repository);

  @override
  Future<Either<Failure, void>> call(DeletePermissionRequestParams params) {
    return repository.deleteRequest(params.requestId);
  }
}

class DeletePermissionRequestParams {
  final String requestId;

  DeletePermissionRequestParams({required this.requestId});
}
