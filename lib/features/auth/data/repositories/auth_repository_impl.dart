import 'package:healthyways/core/error/exceptions.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:healthyways/core/common/entites/profile.dart';
import 'package:healthyways/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, Profile>> getCurrentUserData() async {
    try {
      final profile = await remoteDataSource.getCurrentUserData();

      if (profile == null) {
        return Left(Failure("User is not logged in"));
      }

      return Right(profile);
    } on sb.AuthException catch (e) {
      return Left(Failure(e.message));
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, Profile>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return _getUser(
      () async => await remoteDataSource.signInWithEmailAndPassword(
        email: email,
        password: password,
      ),
    );
  }

  @override
  Future<Either<Failure, Profile>> signUpWithEmailAndPassword({
    required String fName,
    required String lName,
    required String gender,
    required String email,
    required String password,
    required String? selectedRole,
  }) async {
    return _getUser(
      () async => await remoteDataSource.signUpWithEmailAndPassword(
        fName: fName,
        lName: lName,
        gender: gender,
        email: email,
        password: password,
        selectedRole: selectedRole,
      ),
    );
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await remoteDataSource.signOut();
      return const Right(null);
    } on sb.AuthException catch (e) {
      return Left(Failure(e.message));
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }
}

Future<Either<Failure, Profile>> _getUser(Future<Profile> Function() fn) async {
  try {
    final profile = await fn();
    return Right(profile);
  } on sb.AuthException catch (e) {
    return Left(Failure(e.message));
  } on ServerException catch (e) {
    return Left(Failure(e.message));
  }
}
