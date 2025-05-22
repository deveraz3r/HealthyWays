import 'package:healthyways/core/common/controllers/app_profile_controller.dart';
import 'package:healthyways/core/controller/controller_state_manager.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/core/usecase/usecase.dart';
import 'package:healthyways/core/common/entites/profile.dart';
import 'package:healthyways/features/auth/domain/usecases/current_profile.dart';
import 'package:healthyways/features/auth/domain/usecases/user_sign_in.dart';
import 'package:healthyways/features/auth/domain/usecases/user_sign_out.dart';
import 'package:healthyways/features/auth/domain/usecases/user_sign_up.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final UserSignUp _userSignup;
  final UserSignIn _userSignIn;
  final UserSignOut _userSignOut;
  final CurrentProfile _currentProfile;
  final AppProfileController _appProfileController;

  AuthController({
    required UserSignUp userSignup,
    required UserSignIn userSignIn,
    required UserSignOut userSignOut,
    required CurrentProfile currentProfile,
    required AppProfileController appProfileController,
  }) : _userSignup = userSignup,
       _userSignIn = userSignIn,
       _userSignOut = userSignOut,
       _currentProfile = currentProfile,
       _appProfileController = appProfileController;

  final profile = StateController<Failure, Profile>();

  Future<void> getCurrentProfile() async {
    profile.setLoading();

    final result = await _currentProfile(NoParams());

    result.fold(
      (failure) {
        profile.setError(failure);
      },
      (profile) {
        _setProfile(profile);
      },
    );
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String fName,
    required String lName,
    required String gender,
    required String? selectedRole,
  }) async {
    profile.setLoading();

    final result = await _userSignup(
      UserSignUpParams(
        email: email,
        password: password,
        fName: fName,
        lName: lName,
        gender: gender,
        selectedRole: selectedRole,
      ),
    );

    result.fold(
      (failure) {
        profile.setError(failure);
      },
      (user) {
        _setProfile(user);
      },
    );
  }

  Future<void> signIn({required String email, required String password}) async {
    profile.setLoading();

    final result = await _userSignIn(
      UserSignInParams(email: email, password: password),
    );

    result.fold(
      (failure) {
        profile.setError(failure);
      },
      (profile) {
        _setProfile(profile);
      },
    );
  }

  Future<void> signOut() async {
    profile.setLoading();

    final result = await _userSignOut(NoParams());

    result.fold(
      (failure) {
        profile.setError(failure);
      },
      (_) {
        //reset state
        profile.reset();
        _appProfileController.updateProfile(null);
      },
    );
  }

  // ============================= Helper methods =============================

  _setProfile(Profile profile) {
    this.profile.setData(profile);
    _appProfileController.updateProfile(profile);
  }

  // _setErrorMessage(String message) {
  //   errorMessage.value = message;
  //   _setState(ControllerState.ERROR);
  // }

  // _setState(State value) {
  //   profile..value = value;
  //   if (value != ControllerState.ERROR) errorMessage.value = null;
  // }
}
