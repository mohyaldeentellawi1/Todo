import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:todoapp/ui/pages/auth_screen.dart';

import '../theme.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSplashScreen(
        backgroundColor: Get.isDarkMode ? darkGreyClr : primaryClr,
        splashTransition: SplashTransition.fadeTransition,
        nextScreen: const AuthScreen(),
        splash: 'images/icon.png',
        duration: 1600,
        splashIconSize: 350,
      ),
    );
  }
}
