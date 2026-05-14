import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart'; // 1. Import Provider
import '../viewmodels/auth_viewmodel.dart'; // 2. Import AuthViewModel
import 'main_page.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      if (!mounted) return;

      // 3. Cek status login dari AuthViewModel
      final authVM = context.read<AuthViewModel>();

      if (authVM.currentUserEmail != null) {
        // Kalau ada email (udah login), ke Home
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainPage()),
        );
      } else {
        // Kalau belum login, ke Onboarding
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OnboardingScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Teks KINETIC dengan glow
            Text(
              'KINETIC',
              style: GoogleFonts.exo2(
                fontSize: 60,
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.italic,
                color: const Color(0xFFCCFF00),
                shadows: [
                  Shadow(
                    blurRadius: 20.0,
                    color: const Color(0xFFCCFF00).withOpacity(0.8),
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
            ),
            // Teks PUSH YOUR LIMITS
            const Text(
              'P U S H   Y O U R   L I M I T S',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                letterSpacing: 2,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
