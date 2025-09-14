import 'package:healthyways/core/common/custom_types/role.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/core/usecase/usecase.dart';
import 'package:healthyways/core/common/entites/profile.dart';
import 'package:healthyways/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class SignInWithGoogle implements UseCase<Profile, NoParams> {
  final AuthRepository authRepository;
  SignInWithGoogle(this.authRepository);

  @override
  Future<Either<Failure, Profile>> call(params) async {
    return await authRepository.signInWithGoogle();
  }
}
