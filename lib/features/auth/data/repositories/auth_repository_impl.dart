import 'package:flutter/rendering.dart';
import 'package:healthyways/core/common/custom_types/role.dart';
import 'package:healthyways/core/error/exceptions.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:healthyways/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:healthyways/core/common/entites/profile.dart';
// import 'package:healthyways/features/auth/data/models/profile_model.dart';
import 'package:healthyways/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  //TODO: remove this method and getCurrentUserData from controller directly
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

      //also call the rolebase login here if you wan to skip role selection on every login
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
        selectedRole:
            selectedRole != null ? RoleExtension.fromJson(selectedRole) : null,
      ),
    );
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      //remove cache role so user can select new role on login
      localDataSource.clearCachedUserRole();

      await remoteDataSource.signOut();
      return const Right(null);
    } on sb.AuthException catch (e) {
      return Left(Failure(e.message));
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, Profile>> signInWithGoogle() async {
    try {
      // Step 1: Sign in with Google
      final authRes = await remoteDataSource.signInWithGoogle();
      debugPrint("Google Sign-In Response: ${authRes.user}");
      final user = authRes.user;
      if (user == null) {
        return Left(Failure("Google sign-in failed, no user returned"));
      }

      // Step 2: Try to fetch existing base profile
      final baseProfile = await remoteDataSource.getBaseProfile(user.id);
      if (baseProfile != null) {
        // Existing user, return profile
        // You can optionally call roleBasedLogin here
        return Right(baseProfile);
      }

      // Step 3: New user, create base profile
      final fullName =
          user.userMetadata?['full_name'] ?? user.userMetadata?['name'] ?? '';
      String fName = '';
      String lName = '';

      if (fullName.isNotEmpty) {
        final parts = fullName.trim().split(' ');
        fName = parts.first;
        if (parts.length > 1) {
          lName = parts.sublist(1).join(' ');
        }
      }

      await remoteDataSource.createBaseProfile(
        uid: user.id,
        fName: fName,
        lName: lName,
        email: user.email ?? '',
        gender: 'male', // Google doesn’t provide gender by default
        selectedRole: Role.patient,
      );

      // Step 4: Fetch and return the newly created profile
      final newProfile = await remoteDataSource.getBaseProfile(user.id);
      if (newProfile == null) {
        // Error in creating profile
        return Left(Failure("Error in creating base profile"));
      }

      return Right(newProfile);
    } on sb.AuthException catch (e) {
      return Left(Failure(e.message));
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Profile>> roleBasedLogin({
    required String uid,
    required Role selectedRole,
  }) async {
    try {
      debugPrint("fetching Role based profile for $selectedRole");

      debugPrint("Updating base profile with selected role");
      await remoteDataSource.updateProfileRole(
        uid: uid,
        selectedRole: selectedRole,
      );

      ///get role profile if exists
      Profile? roleProfile = await remoteDataSource.getRoleProfile(
        uid,
        selectedRole,
      );
      if (roleProfile != null) {
        debugPrint("Saving $roleProfile in local storage");
        localDataSource.cacheUserRole(selectedRole);

        debugPrint("Role profile found! $roleProfile");
        return Right(roleProfile);
      }

      debugPrint("Unable to find role profile, creating new one");
      await remoteDataSource.createRoleProfile(uid, selectedRole);

      roleProfile = await remoteDataSource.getRoleProfile(uid, selectedRole);
      if (roleProfile == null) {
        debugPrint("Unable to create role profile");
        return Left(Failure("Error in creating role profile"));
      }

      debugPrint("Saving $roleProfile in local storage");
      localDataSource.cacheUserRole(selectedRole);

      debugPrint("Role profile found! $roleProfile");
      return Right(roleProfile);
    } on sb.AuthException catch (e) {
      debugPrint("Auth Exception: ${e.message}");
      return Left(Failure(e.message));
    } on ServerException catch (e) {
      debugPrint("Server Exception: ${e.message}");
      return Left(Failure(e.message));
    } catch (e) {
      debugPrint("Exception: ${e.toString()}");
      return Left(Failure(e.toString()));
    }
  }

  @override
  Either<Failure, Role?> getCachedUserRole() {
    try {
      final response = localDataSource.getCachedUserRole();

      return Right(response);
    } catch (e) {
      debugPrint("Error: ${e.toString()}");
      return Left(Failure(e.toString()));
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
