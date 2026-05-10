import 'package:flutter/material.dart';
import 'package:app/core/theme/app_theme.dart';
import 'package:app/features/student/presentation/widgets/notification_card.dart';
import 'package:app/features/student/data/mock_notifications.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor, 
      appBar: AppBar(
        toolbarHeight: 100, 
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        centerTitle: false,
        leadingWidth: 70, 
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Center(
            child: Container(
              height: 47,
              width: 47,
              decoration: BoxDecoration(
                color: AppTheme.surfaceColor.withValues(alpha:0.1), 
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
                return NotificationCard(notification: mockNotifications[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

}