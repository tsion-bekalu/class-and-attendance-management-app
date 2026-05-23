// features/student/presentation/screens/timetable_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../widgets/time_table_card.dart';
import '../providers/student_providers.dart';

class TimetableScreen extends ConsumerWidget {
  const TimetableScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDay = ref.watch(selectedDayProvider);
    final timetableAsync = ref.watch(timetableProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Column(
        children: [
          _buildHeader(context, ref, selectedDay),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async => ref.invalidate(timetableProvider),
              child: timetableAsync.when(
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Error: $e'),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () => ref.invalidate(timetableProvider),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
                data: (schedule) => schedule.isEmpty
                    ? _buildEmptyState(selectedDay)
                    : ListView.builder(
                        padding: const EdgeInsets.only(top: 10),
                        itemCount: schedule.length,
                        itemBuilder: (context, index) =>
                            TimetableCard(entry: schedule[index]),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String selectedDay) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFFF2F4F7),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.calendar_today_outlined,
                  size: 40, color: Color(0xFF98A2B3)),
            ),
            const SizedBox(height: 24),
            const Text(
              'No Classes Today',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1D2939)),
            ),
            const SizedBox(height: 8),
            Text(
              'Enjoy your free day on $selectedDay',
              style: const TextStyle(fontSize: 16, color: Color(0xFF667085)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
      BuildContext context, WidgetRef ref, String selectedDay) {
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
                        color: Colors.white),
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
            children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri']
                .map((day) => _dayChip(ref, day, day == selectedDay))
                .toList(),
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
