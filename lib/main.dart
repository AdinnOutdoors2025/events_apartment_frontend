import 'package:apartment_client_app/screens/brand_info_screen.dart';
import 'package:apartment_client_app/screens/login_screen.dart';
import 'package:apartment_client_app/screens/register_screen.dart';
import 'package:apartment_client_app/screens/otp_screen.dart';
import 'package:apartment_client_app/screens/onboarding_screen.dart';
import 'package:apartment_client_app/screens/main_navigation.dart';
import 'package:apartment_client_app/screens/brand_profile_screen.dart';
import 'package:apartment_client_app/screens/community_details_screen.dart';
import 'package:apartment_client_app/screens/campaign_builder_screen.dart';
import 'package:apartment_client_app/screens/spaces_screen.dart';
import 'package:apartment_client_app/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.interTextTheme().copyWith(
          headlineLarge: GoogleFonts.inter(fontWeight: FontWeight.bold),
          titleLarge: GoogleFonts.inter(fontWeight: FontWeight.w600),
          bodyMedium: GoogleFonts.inter(fontWeight: FontWeight.w400),
        ),
      ),
      initialRoute: '/splashScreen',
      routes: {
        '/splashScreen': (context) => const SplashScreen(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/otp': (context) => const OtpPage(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/brandProfile': (context) => const BrandProfileScreen(),
        '/brandDetails': (context) => const BrandInfoScreen(),
        '/bottomNav': (context) => const MainNavigation(),
        '/spacesScreen': (context) => const SpacesScreen(),
        '/communityDetails': (context) => const CommunityDetailsScreen(),
        '/campaignBuilder': (context) => const CampaignBuilderScreen(),
      },
    );
  }
}
