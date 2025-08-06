import 'package:fpdart/fpdart.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/core/usecase/usecase.dart';
import 'package:healthyways/features/permission_requests/domain/entities/permission_request.dart';
import 'package:healthyways/features/permission_requests/domain/repositories/premission_requests_repo.dart';

class AddProviderId implements UseCase<void, AddProviderIdParams> {
  final PermissionRequestRepository repository;

  AddProviderId(this.repository);

  @override
  Future<Either<Failure, void>> call(AddProviderIdParams params) {
    return repository.addProviderId(
      providerId: params.providerId,
      patientId: params.patientId,
    );
  }
}

class AddProviderIdParams {
  String providerId;
  String patientId;

  AddProviderIdParams({required this.providerId, required this.patientId});
}
