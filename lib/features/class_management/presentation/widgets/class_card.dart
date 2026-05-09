import 'package:flutter/material.dart';

class ClassCard extends StatelessWidget {
  final String name;
  final String code;
  final String time;
  final String students;
  final int pending;
  final VoidCallback onTap;

  const ClassCard({
    super.key,
    required this.name,
    required this.code,
    required this.time,
    required this.students,
    required this.pending,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha:0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TITLE + STATUS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1D2433),
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD8F7E4),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "active",
                    style: TextStyle(
                      color: Color(0xFF20A15A),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Text(
              "Code: $code",
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF7B8495),
              ),
            ),

            const SizedBox(height: 14),

            Row(
              children: [
                const Icon(Icons.access_time_outlined,
                    size: 18, color: Color(0xFF687082)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    time,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Color(0xFF5E6678),
                    ),
                  ),
                ),
                const Icon(Icons.people_outline,
                    size: 18, color: Color(0xFF687082)),
                const SizedBox(width: 4),
                Text(
                  students,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF5E6678),
                  ),
                ),
              ],
            ),

            if (pending > 0) ...[
              const SizedBox(height: 18),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF2E8),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline,
                        color: Color(0xFFFF6A00), size: 18),
                    const SizedBox(width: 10),
                    Text(
                      "$students pending join requests",
                      style: const TextStyle(
                        color: Color(0xFFFF5C00),
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
