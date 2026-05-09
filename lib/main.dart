import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'package:app/core/routing/app_router.dart';



void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(

      title: 'Class Attendance System',
      theme: AppTheme.lightTheme,
      themeMode: ThemeMode.system,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,

    );
  }
}








