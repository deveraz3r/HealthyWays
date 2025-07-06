import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/core/usecase/usecase.dart';
import 'package:healthyways/core/common/entites/profile.dart';
import 'package:healthyways/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UserSignUp implements UseCase<Profile, UserSignUpParams> {
  AuthRepository authRepository;
  UserSignUp(this.authRepository);

  @override
  Future<Either<Failure, Profile>> call(params) async {
    return await authRepository.signUpWithEmailAndPassword(
      email: params.email,
      password: params.password,
      fName: params.fName,
      lName: params.lName,
      gender: params.gender,
      selectedRole: params.selectedRole,
    );
  }
}

class UserSignUpParams {
  final String fName;
  final String lName;
  final String gender;
  final String email;
  final String password;
  final String? selectedRole;

  UserSignUpParams({
    required this.email,
    required this.password,
    required this.fName,
    required this.lName,
    required this.gender,
    this.selectedRole,
  });
}
