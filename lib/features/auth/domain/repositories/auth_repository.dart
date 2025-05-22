import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/core/common/entites/profile.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, Profile>> getCurrentUserData();

  Future<Either<Failure, Profile>> signUpWithEmailAndPassword({
    required String fName,
    required String lName,
    required String gender,
    required String email,
    required String password,
    required String? selectedRole,
  });

  Future<Either<Failure, Profile>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, void>> signOut();
}
