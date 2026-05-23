import '../../domain/entities/announcement.dart';

class AnnouncementState {
  final List<Announcement> announcements;
  final bool isLoading;

  const AnnouncementState({
    this.announcements = const [],
    this.isLoading = false,
  });

  AnnouncementState copyWith({
    List<Announcement>? announcements,
    bool? isLoading,
  }) {
    return AnnouncementState(
      announcements:
          announcements ??
          this.announcements,
      isLoading:
          isLoading ??
          this.isLoading,
    );
  }
}