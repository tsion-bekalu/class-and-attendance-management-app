import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:app/core/providers/app_providers.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});
  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      final isAuthenticated = ref.read(isAuthenticatedProvider);
      final role = ref.read(userRoleProvider);

      if (!isAuthenticated) {
        context.go('/role_selection');
        return;
      }

      if (role?.toLowerCase() == 'student') {
        context.go('/student/home');
      } else if (role?.toLowerCase() == 'instructor') {
        context.go('/instructor/dashboard');
      } else {
        context.go('/role_selection');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A60FF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo 
            Container(
              width: 90,
              height: 90,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/logo1.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Uni Track',
              style: TextStyle(
                fontSize: 28,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Smart Attendance Management',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white70,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
