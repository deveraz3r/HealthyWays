import 'package:healthyways/core/common/custom_types/role.dart';
import 'package:healthyways/core/common/widgets/loader.dart';
import 'package:healthyways/core/theme/app_pallete.dart';
import 'package:healthyways/features/auth/presentation/controller/auth_controller.dart';
import 'package:healthyways/core/controller/state.dart' as controller;
import 'package:healthyways/features/auth/presentation/widgets/auth_dropdown_field.dart';
import 'package:healthyways/features/auth/presentation/widgets/auth_field.dart';
import 'package:healthyways/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const SignupPage());
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  final AuthController _authController = Get.find();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _genderController = TextEditingController();
  final _roleController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _genderController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _roleController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // _formKey.currentState!.validate();
    return Scaffold(
      appBar: AppBar(backgroundColor: AppPallete.backgroundColor),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Obx(() {
          if (_authController.profile.state == controller.State.loading) {
            return const Loader();
          }

          return Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Sign Up.',
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                AuthField(
                  hintText: "First Name",
                  controller: _firstNameController,
                ),
                const SizedBox(height: 15),
                AuthField(
                  hintText: "Last Name",
                  controller: _lastNameController,
                ),
                const SizedBox(height: 15),
                AuthDropdownField(
                  controller: _genderController,
                  items: const ['Male', 'Female', 'Other'],
                  hintText: "Select Gender",
                ),
                AuthDropdownField(
                  controller: _roleController,
                  items: Role.values.map((e) => e.name).toList(),
                  hintText: "Select Role",
                ),
                const SizedBox(height: 15),
                AuthField(
                  hintText: "Email",
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 15),
                AuthField(
                  hintText: "Password",
                  controller: _passwordController,
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                AuthGradientButton(
                  buttonText: "Sign Up",
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _authController.signUp(
                        fName: _firstNameController.text,
                        lName: _lastNameController.text,
                        gender: _genderController.text,
                        email: _emailController.text,
                        password: _passwordController.text,
                        selectedRole: _roleController.text,
                      );
                    }
                  },
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: RichText(
                    text: TextSpan(
                      text: "Already have an account? ",
                      style: Theme.of(context).textTheme.titleMedium,
                      children: [
                        TextSpan(
                          text: "Login",
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
