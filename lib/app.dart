import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthyways/core/common/controllers/app_profile_controller.dart';
import 'package:healthyways/core/controller/state.dart' as state_enum;
import 'package:healthyways/core/theme/app_theme.dart';
import 'package:healthyways/core/utils/get_home_page_by_role.dart';
import 'package:healthyways/features/auth/presentation/controller/auth_controller.dart';
import 'package:healthyways/features/auth/presentation/pages/role_selection_page.dart';
import 'package:healthyways/features/auth/presentation/pages/sign_in_page.dart';

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final AppProfileController _appProfileController = Get.find();
  final AuthController _authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Healthy Ways',
      theme: AppTheme.darkThemeMode,
      home: Obx(() {
        // final profile = _appProfileController.profile;
        if (_appProfileController.profile.rxState.value ==
            state_enum.State.success) {
          if (_authController.selectedRole.value == null) {
            return RoleSelectionPage();
          } else {
            return getHomePageByRole(_authController.selectedRole.value!);
          }
        } else {
          return LoginPage();
        }
      }),
    );
  }
}
