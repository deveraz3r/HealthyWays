import 'package:fpdart/fpdart.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/core/usecase/usecase.dart';
import 'package:healthyways/features/permission_requests/domain/entities/permission_request.dart';
import 'package:healthyways/features/permission_requests/domain/repositories/premission_requests_repo.dart';

class CreatePermissionRequest
    implements UseCase<void, CreatePermissionRequestParams> {
  final PermissionRequestRepository repository;

  CreatePermissionRequest(this.repository);

  @override
  Future<Either<Failure, void>> call(CreatePermissionRequestParams params) {
    return repository.createPermissionRequest(params.request);
  }
}

class CreatePermissionRequestParams {
  final PermissionRequest request;

  CreatePermissionRequestParams({required this.request});
}
