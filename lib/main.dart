import 'package:apartment_client_app/screens/login_screen.dart';
import 'package:apartment_client_app/screens/register_screen.dart';
import 'package:apartment_client_app/screens/otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';


void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.interTextTheme().copyWith(
          headlineLarge: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
          ),
          titleLarge: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
          ),
          bodyMedium: GoogleFonts.inter(
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/otp': (context) => const OtpPage(),
        '/bottomNav': (context) => const Scaffold(body: Center(child: Text("Home"))), // placeholder
      },
    );
  }
}