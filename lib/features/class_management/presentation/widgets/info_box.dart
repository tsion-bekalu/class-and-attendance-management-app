import 'package:flutter/material.dart';

class InfoBox extends StatelessWidget {
  final String text;

  const InfoBox({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE7F0FF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, color: Color(0xFF1E5EFF)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF1E293B),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
