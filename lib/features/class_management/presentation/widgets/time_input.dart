import 'package:flutter/material.dart';

class TimeInput extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const TimeInput({
    super.key,
    required this.label,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF6D7485))),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: "11:30",
            prefixIcon: const Icon(Icons.access_time_outlined,
                color: Color(0xFF9AA3B2)),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 18),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFD9DDE5)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFF1E5EFF)),
            ),
          ),
        ),
      ],
    );
  }
}
