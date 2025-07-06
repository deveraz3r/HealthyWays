import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthyways/core/theme/app_pallete.dart';
import 'package:healthyways/features/auth/presentation/controller/auth_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // final AuthController _authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // // Create a future that delays for 3 seconds
    // final timer = Future.delayed(const Duration(seconds: 3));

    // // Get user profile (or any other initialization logic)
    // final initialization = _authController.getCurrentProfile();

    // // Wait for both the timer and initialization to complete
    // await Future.wait([timer, initialization]);

    // // After both complete, check authentication status
    // if (_authController.profile.data != null) {
    //   Get.offAll(() => _authController.getHomeScreenForRole());
    // } else {
    //   Get.offAll(() => const LoginPage());
    // }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: Scaffold(
        backgroundColor: AppPallete.backgroundColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo Container with gradient border
              Icon(Icons.medical_services_rounded, size: 80, color: AppPallete.gradient1),
              const SizedBox(height: 30),
              // App Name
              ShaderMask(
                shaderCallback:
                    (bounds) =>
                        LinearGradient(colors: [AppPallete.gradient1, AppPallete.gradient2]).createShader(bounds),
                child: const Text(
                  'Healthy Ways.',
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              const SizedBox(height: 10),
              // Tagline
              Text(
                'Your Health, Your Way',
                style: TextStyle(fontSize: 16, color: AppPallete.greyColor, letterSpacing: 1.2),
              ),
              const SizedBox(height: 50),
              // // Loading indicator
              // SizedBox(
              //   width: 40,
              //   height: 40,
              //   child: CircularProgressIndicator(
              //     valueColor: AlwaysStoppedAnimation<Color>(AppPallete.gradient1),
              //     strokeWidth: 2,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
