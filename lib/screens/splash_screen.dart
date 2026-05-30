import 'package:flutter/material.dart';

import '../constants/color.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: AppColors.border,
      body: Center(
        child: Image.asset(
          AppImages.logo,
          width: double.infinity,
          height: 40,
          fit: BoxFit.fill,
          alignment: Alignment.topCenter,
        ),
      ),
    );
  }
}
