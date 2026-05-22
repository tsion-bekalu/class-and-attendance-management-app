import 'package:flutter_riverpod/legacy.dart';
import '../../domain/entities/announcement.dart';
import '../../data/mock_announcement_data.dart';

final announcementProvider =
    StateNotifierProvider<AnnouncementNotifier, List<Announcement>>((ref) {
  return AnnouncementNotifier();
});

class AnnouncementNotifier extends StateNotifier<List<Announcement>> {
  AnnouncementNotifier() : super(mockAnnouncements);

  void addAnnouncement(Announcement announcement) {
    state = [announcement, ...state];
  }

  void deleteAnnouncement(Announcement announcement) {
    state = state.where((a) => a != announcement).toList();
  }
}