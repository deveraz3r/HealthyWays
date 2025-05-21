import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/core/usecase/usecase.dart';
import 'package:healthyways/core/common/entites/profile.dart';
import 'package:healthyways/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class CurrentProfile implements UseCase<Profile, NoParams> {
  AuthRepository authRepository;
  CurrentProfile(this.authRepository);

  @override
  Future<Either<Failure, Profile>> call(params) async {
    return await authRepository.getCurrentUserData();
  }
}
