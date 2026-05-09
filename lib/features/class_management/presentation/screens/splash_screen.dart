import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ClassManagementSplashScreen extends StatefulWidget {
  const ClassManagementSplashScreen({super.key});

  @override
  State<ClassManagementSplashScreen> createState() =>
      _ClassManagementSplashScreenState();
}

class _ClassManagementSplashScreenState
    extends State<ClassManagementSplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      context.go('/instructor/dashboard');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo1.png'),
            const SizedBox(height: 20),
            const Text(
              'Uni Track',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Smart Attendance Management',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
