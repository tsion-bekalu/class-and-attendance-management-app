import 'package:flutter_riverpod/legacy.dart';

import '../../domain/entities/announcement.dart';
import '../../data/announcement_database.dart';

final announcementProvider =
    StateNotifierProvider<AnnouncementNotifier, List<Announcement>>((ref) {
  return AnnouncementNotifier();
});

class AnnouncementNotifier extends StateNotifier<List<Announcement>> {
  final AnnouncementDatabase _database = AnnouncementDatabase();

  AnnouncementNotifier() : super([]) {
    loadAnnouncements();
  }

  Future<void> loadAnnouncements() async {
    final announcements =
        await _database.getAnnouncements();

    state = announcements;
  }

  Future<void> addAnnouncement(
    Announcement announcement,
  ) async {
    await _database.insertAnnouncement(
      announcement,
    );

    await loadAnnouncements();
    print("ADDING: ${announcement.title}");
  }

  Future<void> deleteAnnouncement(
    Announcement announcement,
  ) async {
    await _database.deleteAnnouncement(
      announcement.title,
    );

    await loadAnnouncements();
  }
}