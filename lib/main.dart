//import 'package:app/features/auth/presentation/screens/first.dart';
import 'package:app/core/routing/app_%20router.dart';
import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';



void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter, // This connects your GoRouter file to the app
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
    );
  }
}

