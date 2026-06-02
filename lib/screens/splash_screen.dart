import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/color.dart';
import '../providers/splash_screen_providers.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(splashProvider.notifier).startSplash();
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<bool>(splashProvider, (_, isCompleted) {
      if (isCompleted) {
        Navigator.pushNamed(context, '/onboarding');
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(60.0),
        child: SizedBox.expand(
          child: SvgPicture.asset(
            AppImages.splashScreen,
          )
        ),
      ),
    );
  }
}
