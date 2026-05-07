import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:class-and-attendance-management-app/core/theme/app_theme.dart';

class RegisterScreen extends StatelessWidget {
  final String role; // Receives 'Instructor' or 'Student'
  const RegisterScreen({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register as $role', style: const TextStyle(fontSize: 18)),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              'Create $role Account', 
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text('Please fill in the details to get started'),
            const SizedBox(height: 30),

            // COMMON FIELD: Full Name
            const TextField(
              decoration: InputDecoration(
                labelText: 'Full Name',
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 16),

            // ROLE-SPECIFIC FIELD
            if (role == 'Student')
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Student ID Number',
                  prefixIcon: Icon(Icons.badge_outlined),
                  hintText: 'e.g. ATR/1234/12',
                ),
              )
            else
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Department',
                  prefixIcon: Icon(Icons.account_balance_outlined),
                  hintText: 'e.g. Computer Science',
                ),
              ),
            
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Email Address',
                prefixIcon: Icon(Icons.email_outlined),
              ),
            ),
            const SizedBox(height: 16),
            const TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock_outline),
              ),
            ),
            const SizedBox(height: 32),

            ElevatedButton(
              onPressed: () {
                // Show a success message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$role Account Created Successfully!')),
                );
                context.go('/login');
              },
              child: const Text('Create Account'),
            ),
          ],
        ),
      ),
    );
  }
}