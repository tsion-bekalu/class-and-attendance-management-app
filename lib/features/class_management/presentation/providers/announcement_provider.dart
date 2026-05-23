import 'package:flutter_riverpod/legacy.dart';
import '../../domain/entities/announcement.dart';
import '../../data/announcement_database.dart';

final announcementProvider = StateNotifierProvider.family<
    AnnouncementNotifier,
    List<Announcement>,
    String>((ref, classId) {
  return AnnouncementNotifier(classId);
});

class AnnouncementNotifier extends StateNotifier<List<Announcement>> {
  final AnnouncementDatabase _database = AnnouncementDatabase();
  final String classId;

  AnnouncementNotifier(this.classId) : super([]) {
    loadAnnouncements();
  }

  Future<void> loadAnnouncements() async {
    final announcements =
        await _database.getAnnouncements(classId);

    state = announcements;
  }

  Future<void> addAnnouncement(
    Announcement announcement,
  ) async {
    await _database.insertAnnouncement(
      announcement,
    );

    await loadAnnouncements();
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