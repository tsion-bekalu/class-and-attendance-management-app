import 'package:flutter/material.dart';

class DayChip extends StatelessWidget {
  final String day;
  final bool selected;
  final VoidCallback onTap;

  const DayChip({
    super.key,
    required this.day,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF1E5EFF) : const Color(0xFFF1F2F6),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          day,
          style: TextStyle(
            fontSize: 16,
            color: selected ? Colors.white : const Color(0xFF374151),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
