import 'package:healthyways/core/error/exceptions.dart';
import 'package:healthyways/features/auth/data/models/profile_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDataSource {
  Session? get currentUserSession;

  Future<ProfileModel?> getCurrentUserData();

  Future<ProfileModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<ProfileModel> signUpWithEmailAndPassword({
    required String fName,
    required String lName,
    required String gender,
    required String email,
    required String password,
    required String selectedRole,
  });

  Future<void> signOut();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;
  AuthRemoteDataSourceImpl(this.supabaseClient);

  @override
  Session? get currentUserSession => supabaseClient.auth.currentSession;

  @override
  Future<ProfileModel?> getCurrentUserData() async {
    try {
      if (currentUserSession == null) {
        return null;
      }

      // Fetch base user data from "users" table
      final baseResponse =
          await supabaseClient
              .from("profiles")
              .select()
              .eq("uid", currentUserSession!.user.id)
              .single();

      final baseProfile = ProfileModel.fromJson(
        baseResponse,
      ).copyWith(email: currentUserSession!.user.email);

      return baseProfile;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<ProfileModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw ServerException("User is null");
      }

      final ProfileModel? profile = await getCurrentUserData();

      return profile!;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<ProfileModel> signUpWithEmailAndPassword({
    required String fName,
    required String lName,
    required String gender,
    required String email,
    required String password,
    required String selectedRole,
  }) async {
    try {
      final response = await supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {
          "fName": fName,
          "lName": lName,
          "gender": gender,
          "selectedRole": selectedRole,
        },
      );

      if (response.user == null) {
        throw ServerException("User is null");
      }

      final ProfileModel? profile = await getCurrentUserData();

      return profile!;
    } catch (e) {
      await signOut(); //if auth is succesful but userdata is not found
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await supabaseClient.auth.signOut();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
