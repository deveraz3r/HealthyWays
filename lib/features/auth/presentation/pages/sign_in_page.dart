import 'package:healthyways/core/common/widgets/loader.dart';
import 'package:healthyways/core/theme/app_pallete.dart';
import 'package:healthyways/core/utils/show_snackbar.dart';
import 'package:healthyways/features/auth/presentation/controller/auth_controller.dart';
import 'package:healthyways/core/controller/state.dart' as controller;
import 'package:healthyways/features/auth/presentation/pages/sign_up_page.dart';
import 'package:healthyways/features/auth/presentation/widgets/auth_field.dart';
import 'package:healthyways/core/common/widgets/primary_gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const LoginPage());
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final AuthController _authController = Get.find();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _authController.getCurrentProfile();

    // Listen for state changes and show Snackbar on error
    ever(_authController.profile.rxState, (state) {
      if (state == controller.State.error) {
        final errorMessage =
            _authController.profile.errorMessage?.message ??
            "An error occurred.";
        showSnackbar(context, errorMessage);
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: AppPallete.backgroundColor),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Obx(() {
          if (_authController.profile.state == controller.State.loading) {
            return Loader();
          }

          return Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Sign In.',
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                AuthField(hintText: "Email", controller: _emailController),
                const SizedBox(height: 15),
                AuthField(
                  hintText: "Password",
                  controller: _passwordController,
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                PrimaryGradientButton(
                  buttonText: "Login",
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _authController.signIn(
                        email: _emailController.text,
                        password: _passwordController.text,
                      );
                    }
                  },
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    Navigator.push(context, SignupPage.route());
                  },
                  child: RichText(
                    text: TextSpan(
                      text: 'Don\'t have an account? ',
                      style: Theme.of(context).textTheme.titleMedium,
                      children: [
                        TextSpan(
                          text: "Sign Up",
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(color: AppPallete.gradient2),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
