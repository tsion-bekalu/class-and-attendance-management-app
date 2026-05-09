import 'package:flutter/material.dart';
import '../../../../core/routing/theme/app_theme.dart';
import 'package:app/features/student/presentation/widgets/time_table_card.dart';
import 'package:app/features/student/data/mock_timetable.dart';

class TimetableScreen extends StatelessWidget {
  const TimetableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Using your theme's background color
      backgroundColor: AppTheme.backgroundColor,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 10),
              itemCount: mockSchedule.length,
              itemBuilder: (context, index) {
                return TimetableCard(entry: mockSchedule[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
  return Container(
    padding: const EdgeInsets.fromLTRB(24, 0, 24, 36),
    width: double.infinity,
    decoration: const BoxDecoration(
      color: AppTheme.primaryColor,
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(32),
        bottomRight: Radius.circular(32),
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 40,),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.zero,
              ),
            ),

            const SizedBox(width: 16),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Timetable",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Inter',
                  ),
                ),

                SizedBox(height: 1),

                Text(
                  "Weekly class schedule",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 32),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri']
              .map((day) => _dayChip(day, day == 'Mon'))
              .toList(),
        ),
      ],
    ),
  );
}
  Widget _dayChip(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? AppTheme.primaryColor : Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

