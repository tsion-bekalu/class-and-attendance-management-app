import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:class-and-attendance-management-app/features/auth/data/mock_auth_service.dart';

class LoginScreen extends StatefulWidget {
  final String role;
  const LoginScreen({super.key, required this.role});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login as ${widget.role}')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Image.asset('assets/logo1.png', height: 60),
            const SizedBox(height: 20),
            Text('Welcome Back', style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 40),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email', hintText: 'instructor@uni.com or student@uni.com'),
            ),
            const SizedBox(height: 16),
            const TextField(obscureText: true, decoration: InputDecoration(labelText: 'Password')),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                final user = MockAuthService.login(_emailController.text);
                if (user != null) {
                  user.role.name == 'instructor' ? context.go('/instructor/classes') : context.go('/student/timetable');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('User not found in Mock Data')));
                }
              },
              child: const Text('Sign In'),
            ),
            TextButton(onPressed: () => context.push('/register'), child: const Text("Don't have an account? Sign Up")),
          ],
        ),
      ),
    );
  }
}