import 'package:flutter/material.dart';
import 'package:healthyways/core/common/custom_types/role.dart';
import 'package:healthyways/core/common/entites/profile.dart';
import 'package:healthyways/core/constants/supabase/supabase_tables.dart';
import 'package:healthyways/core/error/exceptions.dart';
import 'package:healthyways/features/auth/data/factories/profile_factory.dart';
import 'package:healthyways/features/auth/data/models/profile_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDataSource {
  Session? get currentUserSession;

  Future<Profile?> getCurrentUserData();

  Future<Profile> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> updateProfileRole({
    required Role selectedRole,
    required String uid,
  });

  Future<Profile> signInWithGoogle();

  Future<Profile> signUpWithEmailAndPassword({
    required String fName,
    required String lName,
    required String gender,
    required String email,
    required String password,
    required String? selectedRole,
  });

  Future<void> signOut();

  Future<Profile?> getBaseProfile(String uid);

  Future<Profile?> getRoleProfile(String uid, Role selectedRole);

  Future<void> createRoleProfile(String uid, Role selectedRole);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;
  AuthRemoteDataSourceImpl(this.supabaseClient);

  @override
  Session? get currentUserSession => supabaseClient.auth.currentSession;

  @override
  Future<Profile?> getCurrentUserData() async {
    try {
      if (currentUserSession == null) {
        return null;
      }

      // Fetch base user data from "profiles" table
      final baseResponse =
          await supabaseClient
              .from(SupabaseTables.baseProfileTable)
              .select()
              .eq("uid", currentUserSession!.user.id)
              .single();

      final role = RoleExtension.fromJson(baseResponse['selectedRole']);

      // Based on role, fetch complete profile from appropriate view
      final response =
          await supabaseClient
              .from(_getRoleView(role))
              .select()
              .eq("uid", currentUserSession!.user.id)
              .single();

      return ProfileFactory.createProfileFromJson(response);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Profile> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      if (currentUserSession != null) {
        throw ServerException("User already signed in");
        //optionally you can sign out the current user
      }

      final response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw ServerException("User is null");
      }

      final Profile? profile = await getCurrentUserData();

      return profile!;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Profile> signUpWithEmailAndPassword({
    required String fName,
    required String lName,
    required String gender,
    required String email,
    required String password,
    required String? selectedRole,
  }) async {
    try {
      final response = await supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {
          "fName": fName,
          "lName": lName,
          "gender": gender,
          "selectedRole": selectedRole?.toLowerCase() ?? "patient",
        },
      );

      if (response.user == null) {
        throw ServerException("User is null");
      }

      await supabaseClient.from(SupabaseTables.baseProfileTable).insert({
        "uid": response.user!.id, // Pass the user ID as uid
        "email": email,
        "fName": fName,
        "lName": lName,
        "gender": gender,
        "selectedRole": selectedRole?.toLowerCase(),
      });

      final Profile? profile = await getCurrentUserData();

      return profile!;
    } catch (e) {
      debugPrint("Signing Out...");
      await signOut(); // If auth is successful but userdata is not found
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

  @override
  Future<Profile> signInWithGoogle() {
    if (currentUserSession != null) {
      throw ServerException("User already signed in");
    }

    // TODO: implement signInWithGoogle
    throw UnimplementedError();
  }

  @override
  Future<void> createRoleProfile(String uid, Role selectedRole) async {
    if (currentUserSession == null) {
      throw ServerException("User not signed in");
    }

    try {
      // Insert a new row in the role-specific table with only the uid
      await supabaseClient.from(_getRoleTable(selectedRole)).insert({
        "uid": uid,
      });
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Profile?> getBaseProfile(String uid) async {
    if (currentUserSession == null) {
      throw ServerException("User not signed in");
    }

    try {
      final response =
          await supabaseClient
              .from(SupabaseTables.baseProfileTable)
              .select()
              .eq("uid", uid)
              .maybeSingle();

      if (response == null) return null;

      return ProfileModel.fromJson(response);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Profile?> getRoleProfile(String uid, Role selectedRole) async {
    if (currentUserSession == null) {
      throw ServerException("User not signed in");
    }

    try {
      final response =
          await supabaseClient
              .from(_getRoleView(selectedRole))
              .select()
              .eq("uid", uid)
              .maybeSingle();

      if (response == null) return null;

      return ProfileFactory.createProfileFromJson(response);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  //maybe change the updateRole to update entire profile for reasuablity
  @override
  Future<void> updateProfileRole({
    required Role selectedRole,
    required String uid,
  }) async {
    if (currentUserSession == null) {
      throw ServerException("User not signed in");
    }

    try {
      await supabaseClient
          .from(SupabaseTables.baseProfileTable)
          .update({"selectedRole": selectedRole.toJson()})
          .eq("uid", uid);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}

String _getRoleTable(Role role) {
  switch (role) {
    case Role.patient:
      return SupabaseTables.patientsTable;
    case Role.doctor:
      return SupabaseTables.doctorsTable;
    case Role.pharmacist:
      return SupabaseTables.pharmacistsTable;
    default:
      throw ServerException("Invalid role");
  }
}

String _getRoleView(Role role) {
  switch (role) {
    case Role.patient:
      return SupabaseTables.fullPatientProfilesView;
    case Role.doctor:
      return SupabaseTables.fullDoctorProfilesView;
    case Role.pharmacist:
      return SupabaseTables.fullPharmacistProfilesView;
    default:
      return SupabaseTables.baseProfileTable;
  }
}
