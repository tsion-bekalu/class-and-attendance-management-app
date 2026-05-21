import 'package:flutter_riverpod/legacy.dart';
import '../../domain/entities/announcement.dart';
import 'announcement_state.dart';

class AnnouncementNotifier
    extends StateNotifier<
        AnnouncementState> {
  AnnouncementNotifier()
      : super(
          const AnnouncementState(),
        ) {
    loadAnnouncements();
  }

  void loadAnnouncements() {
    state = state.copyWith(
      announcements: [
        Announcement(
          title:
              "Class Cancelled - Monday",
          message:
              "Please note that Monday's class has been cancelled due to a faculty meeting. We will resume on Wednesday.",
          dateTime:
              "2026-04-10 2:30 PM",
        ),
        Announcement(
          title:
              "Assignment Due Date Extended",
          message:
              "The deadline for Assignment 3 has been extended to April 20th. Please submit your work by then.",
          dateTime:
              "2026-04-10 10:30 AM",
        ),
      ],
    );
  }

  void createAnnouncement({
    required String title,
    required String message,
  }) {
    final newAnnouncement =
        Announcement(
      title: title,
      message: message,
      dateTime:
          DateTime.now().toString(),
    );

    state = state.copyWith(
      announcements: [
        newAnnouncement,
        ...state.announcements,
      ],
    );
  }
}

final announcementProvider =
    StateNotifierProvider<
      AnnouncementNotifier,
      AnnouncementState
    >(
  (ref) =>
      AnnouncementNotifier(),
);