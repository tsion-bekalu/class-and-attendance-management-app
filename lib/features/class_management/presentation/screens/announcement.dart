import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/announcement.dart';
import '../../data/mock_announcement_data.dart';

class AnnouncementsScreen extends StatelessWidget {
  const AnnouncementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Column(
        children: [
          // Reuse header logic
          _buildHeader(context),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              itemCount: mockAnnouncements.length,
              itemBuilder: (context, index) {
                return _buildAnnouncementCard(mockAnnouncements[index]);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to new announcement screen
          context.pushNamed('instructor-create-announcement');
        },
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 30),
      width: double.infinity,
      decoration: const BoxDecoration(color: AppTheme.primaryColor),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
              onPressed: () => context.pop(),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Announcements",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                "Computer Science",
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Individual Card implementation
  Widget _buildAnnouncementCard(Announcement announcement) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            announcement.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            announcement.message,
            style: const TextStyle(color: AppTheme.textSecondary, height: 1.4),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(
                Icons.access_time_rounded,
                size: 16,
                color: Colors.black38,
              ),
              const SizedBox(width: 6),
              Text(
                announcement.dateTime,
                style: const TextStyle(color: Colors.black38, fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }
}