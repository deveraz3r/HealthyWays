import 'package:fpdart/fpdart.dart';
import 'package:healthyways/core/common/custom_types/role.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/core/usecase/usecase.dart';
import 'package:healthyways/features/permission_requests/domain/entities/permission_request.dart';
import 'package:healthyways/features/permission_requests/domain/repositories/premission_requests_repo.dart';
import 'package:healthyways/features/permission_requests/domain/usecases/get_outgoing_permission_requests.dart';

class GetIncomingPermissionRequests
    implements UseCase<List<PermissionRequest>, GetPermissionRequestsParams> {
  final PermissionRequestRepository repository;

  GetIncomingPermissionRequests(this.repository);

  @override
  Future<Either<Failure, List<PermissionRequest>>> call(params) {
    return repository.getIncomingRequests(params.userId, params.role);
  }
}

// class GetPermissionRequestsParams {
//   final String userId;
//   final Role role;

//   GetPermissionRequestsParams({required this.userId, required this.role});
// }
