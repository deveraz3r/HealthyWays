import 'package:fpdart/fpdart.dart';
import 'package:healthyways/core/common/entites/profile.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/core/usecase/usecase.dart';
import 'package:healthyways/features/permission_requests/domain/repositories/premission_requests_repo.dart';

class GetProfileDataById implements UseCase<Profile, GetProfileDataByIdParams> {
  final PermissionRequestRepository repository;

  GetProfileDataById(this.repository);

  @override
  Future<Either<Failure, Profile>> call(params) {
    return repository.getProfileDataById(params.uid);
  }
}

class GetProfileDataByIdParams {
  final String uid;

  GetProfileDataByIdParams({required this.uid});
}
