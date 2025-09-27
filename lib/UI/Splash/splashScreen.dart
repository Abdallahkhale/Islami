import 'package:flutter/material.dart';
import 'package:islami/Core/Assets/ImagesPath.dart';
import 'package:islami/Core/Services/LocalStorage.dart';
import 'package:islami/Core/Services/localStorageKeys.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      _navigateBasedOnOnboarding();
    });
  }

  void _navigateBasedOnOnboarding() async {
    
    bool? isOnboardingCompleted = LocalStorage.getBool(Localstoragekeys.onboardingCmpleted) ?? false;
    if (isOnboardingCompleted) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/onboarding');
    }

   
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Image.asset(
          ImagesPath.splash,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
