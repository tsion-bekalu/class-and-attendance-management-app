import 'package:flutter/material.dart';

class ClassListScreen extends StatelessWidget {
  const ClassListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Classes")),
      body: const Center(child: Text("Class List")),
    );
  }
}
