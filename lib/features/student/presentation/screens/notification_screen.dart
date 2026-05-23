// features/student/presentation/screens/notification_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/core/theme/app_theme.dart';
import '../widgets/notification_card.dart';
import '../providers/student_providers.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationsNotifierProvider);

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
                color: AppTheme.surfaceColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back,
                    color: AppTheme.surfaceColor, size: 20),
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.zero,
              ),
            ),
          ),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: AppTheme.surfaceColor,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          // Mark all as read button
          notificationsAsync.whenOrNull(
            data: (list) => list.any((n) => n.isUnread)
                ? TextButton(
                    onPressed: () {
                      for (final n in list.where((n) => n.isUnread)) {
                        ref
                            .read(notificationsNotifierProvider.notifier)
                            .markAsRead(n.id);
                      }
                    },
                    child: const Text('Mark all read',
                        style: TextStyle(color: Colors.white70, fontSize: 12)),
                  )
                : null,
          ) ?? const SizedBox.shrink(),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(notificationsNotifierProvider),
        child: notificationsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: $e'),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () =>
                      ref.invalidate(notificationsNotifierProvider),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
          data: (notifications) => notifications.isEmpty
              ? const Center(
                  child: Text('No notifications.',
                      style: TextStyle(color: AppTheme.textSecondary)),
                )
              : ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final n = notifications[index];
                    return GestureDetector(
                      onTap: () {
                        if (n.isUnread) {
                          ref
                              .read(notificationsNotifierProvider.notifier)
                              .markAsRead(n.id);
                        }
                      },
                      child: NotificationCard(notification: n),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
