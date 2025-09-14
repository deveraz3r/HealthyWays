import 'package:healthyways/core/common/custom_types/role.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/core/usecase/usecase.dart';
import 'package:healthyways/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetCachedUserRole implements UseCase<Role?, NoParams> {
  final AuthRepository authRepository;
  GetCachedUserRole(this.authRepository);

  @override
  Future<Either<Failure, Role?>> call(params) async {
    return authRepository.getCachedUserRole();
  }
}
