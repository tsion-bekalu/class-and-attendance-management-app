import 'package:flutter/material.dart';
import 'package:app/core/routing/theme/app_theme.dart';
import 'package:app/features/student/presentation/widgets/notification_card.dart';
import 'package:app/features/student/data/mock_notifications.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Background color from our central theme
      backgroundColor: AppTheme.backgroundColor, 
      appBar: AppBar(
        toolbarHeight: 100, 
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        centerTitle: false,
        // Giving enough space for the custom back button
        leadingWidth: 70, 
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Center(
            child: Container(
              height: 47,
              width: 47,
              decoration: BoxDecoration(
                // Matching the translucent circle style from Class Detail
                color: AppTheme.surfaceColor.withOpacity(0.1), 
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: AppTheme.surfaceColor, size: 20),
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.zero,
              ),
            ),
          ),
        ),
        title: const Text(
          "Notifications",
          style: TextStyle(
            color: AppTheme.surfaceColor, 
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: mockNotifications.length,
              itemBuilder: (context, index) {
                // Now using the separate NotificationCard file we just fixed!
                return NotificationCard(notification: mockNotifications[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

}