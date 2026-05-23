import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:app/core/theme/app_theme.dart';
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
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Check for existing authentication session
    final authState = ref.read(authStateProvider.notifier);
    await authState.checkAuthStatus();

    // Wait a bit for splash effect
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      final authValue = ref.read(authStateProvider);
      
      // Check if user is authenticated
      if (authValue.hasValue && authValue.value != null) {
        final userRole = authValue.value!.role;
        
        // Update global state
        ref.read(isAuthenticatedProvider.notifier).set(true);
        ref.read(userRoleProvider.notifier).set(userRole);
        ref.read(currentUserProvider.notifier).set({
          'name': authValue.value!.name,
          'email': authValue.value!.email,
          'role': userRole,
        });

        // Navigate based on role
        if (userRole.toLowerCase() == 'instructor') {
          context.go('/instructor/dashboard');
        } else {
          context.go('/student/home');
        }
      } else {
        // No session found, go to role selection
        context.go('/role_selection');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
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
            
            // App Title
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
            
            // Subtitle
            const Text(
              'Smart Attendance Management',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white70,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 60),
            
            // Loading indicator
            const SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.white),
                strokeWidth: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
