import 'package:app/features/student/presentation/providers/student_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/class_provider.dart';
import '../../../student/presentation/widgets/time_table_card.dart';
import '../../../student/domain/models/student_models.dart';

class InstructorTimetableScreen extends ConsumerWidget {
  const InstructorTimetableScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final classes = ref.watch(classProvider).classes;
    final selectedDay = ref.watch(selectedDayProvider);

    // Convert instructor classes → timetable entries
    final schedule = classes.expand((c) {
      return c.days.map((day) {
        return TimetableEntry(
          id: c.id,
          classId: c.id,
          title: c.name,
          courseCode: c.id,
          day: day,
          time: '${c.startTime} - ${c.endTime}',
          location: 'Classroom',
          duration: '${c.startTime} - ${c.endTime}',
          accentColor: const Color(0xFF1E5EFF),
        );
      });
    }).toList();
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Column(
        children: [
          _buildHeader(context, ref, selectedDay),
          Expanded(
            child: schedule.isEmpty
                ? const Center(
                    child: Text(
                      'No Classes Scheduled',
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 10),
                    itemCount: schedule.length,
                    itemBuilder: (context, index) {
                      return TimetableCard(entry: schedule[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref, String selectedDay) {
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
          const SizedBox(height: 50),

          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),

              const SizedBox(width: 8),

              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Timetable',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Weekly class schedule',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 32),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              'Mon',
              'Tue',
              'Wed',
              'Thu',
              'Fri',
            ].map((day) => _dayChip(ref, day, day == selectedDay)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _dayChip(WidgetRef ref, String label, bool isSelected) {
    return GestureDetector(
      onTap: () => ref.read(selectedDayProvider.notifier).state = label,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
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
      ),
    );
  }
}
