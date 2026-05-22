import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const StatCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha:0.18),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Colors.white24,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.white70, fontSize: 15)),
                const SizedBox(height: 5),
                Text(value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
