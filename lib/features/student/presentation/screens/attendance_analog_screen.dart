// features/student/presentation/screens/attendance_analog_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';

/// The entry-point screen where students choose between QR scan or manual code.
/// [classId] is passed so the subsequent screens know which class to submit for.
class AttendanceScanScreen extends StatelessWidget {
  final String classId;

  const AttendanceScanScreen({super.key, required this.classId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Column(
        children: [
          _buildHeader(context),
          const Spacer(),
          _buildActionCard(context),
          const Spacer(flex: 2),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 30),
      width: double.infinity,
      decoration: const BoxDecoration(color: AppTheme.primaryColor),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const SizedBox(width: 16),
          const Text(
            'Attendance',
            style: TextStyle(
                color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Mark Your Attendance',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 8),
          const Text(
            'Scan QR code or enter session code',
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 32),

          // SCAN QR CODE
          ElevatedButton.icon(
            onPressed: () => context.pushNamed(
              'scanner-screen',
              queryParameters: {'classId': classId},
            ),
            icon: const Icon(Icons.qr_code_scanner, color: AppTheme.primaryColor),
            label: const Text('Scan QR Code'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppTheme.primaryColor,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 16),

          // ENTER CODE MANUALLY
          ElevatedButton.icon(
            onPressed: () => context.pushNamed(
              'manual-code-entry',
              queryParameters: {'classId': classId},
            ),
            icon: const Icon(Icons.keyboard_outlined, color: Colors.white),
            label: const Text('Enter Code Manually'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.2),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 0,
              side: const BorderSide(color: Colors.white24),
            ),
          ),
        ],
      ),
    );
  }
}
