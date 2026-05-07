import 'package:flutter/material.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo1.png'),
            SizedBox(height: 20),
            Text(
              'Uni Track',
              style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight(800)),
            ),
            SizedBox(height: 10),
            Text(
              'Smart Attendance Management',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}