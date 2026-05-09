import 'package:flutter/material.dart';
import 'package:app/features/student/domain/models/notification.dart';

class AppTheme {
  // Brand Colors
  static const Color primaryColor = Color(0xFF155DFC); 
  static const Color secondaryColor = Color(0xFF625B71);
  static const Color accentBlue = Color(0xFFE7EEFF); 
  
  // Status & Category Colors
  static const Color successColor = Color(0xFF107C10);
  static const Color errorColor = Color(0xFFBA1A1A);
  static const Color warningOrange = Color(0xFFF2994A); // Added for Alerts
  static const Color infoPurple = Color(0xFF9B51E0);   // Added for Reminders

  // Soft Backgrounds (For Badges/Icons)
  static const Color softOrange = Color(0xFFFFF3E0);
  static const Color softPurple = Color(0xFFF3E5F5);
  
  // Neutral Colors
  static const Color backgroundColor = Color(0xFFF8F9FD);
  static const Color surfaceColor = Colors.white;
  static const Color textPrimary = Color(0xFF1C1B1F);
  static const Color textSecondary = Color(0xFF757575);

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: 'Inter',


    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: surfaceColor,
      error: errorColor,
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: surfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.withOpacity(0.1)),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
    ),
    // Setup consistent chip theme for the filters
    chipTheme: ChipThemeData(
      backgroundColor: const Color(0xFFF1F3F4),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      labelStyle: const TextStyle(color: textSecondary, fontSize: 13),
    ),
  );
}
final styleMap = {
      NotificationType.announcement: {
        'bg': const Color(0xFFE3F2FD), // Very light blue
        'icon': AppTheme.primaryColor,
        'data': Icons.campaign_rounded,
      },
      NotificationType.alert: {
        'bg': const Color(0xFFFFF3E0), // Very light orange
        'icon': Colors.orange[800],
        'data': Icons.report_problem_rounded,
      },
      NotificationType.reminder: {
        'bg': const Color(0xFFF3E5F5), // Very light purple
        'icon': Colors.purple[400],
        'data': Icons.notifications_rounded,
      },
    };
