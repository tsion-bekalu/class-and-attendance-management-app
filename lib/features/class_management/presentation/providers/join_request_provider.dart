import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/core/providers/app_providers.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'join_request_state.dart';

class JoinRequestNotifier
    extends StateNotifier<
        JoinRequestState> {
  final Ref ref;

  JoinRequestNotifier(this.ref)
      : super(
          const JoinRequestState(),
        );

  Future<void> loadRequests(
    String classId,
  ) async {
    try {
      state = state.copyWith(
        isLoading: true,
      );

      final repository = ref.read(
        classRepositoryProvider,
      );

      final pending =
          await repository
              .getPendingRequests(
        classId,
      );

      final processed =
          await repository
              .getProcessedRequests(
        classId,
      );

      state = state.copyWith(
        pendingRequests:
            pending,
        processedRequests:
            processed,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> approveRequest({
    required String classId,
    required String studentId,
  }) async {
    try {
      final repository = ref.read(
        classRepositoryProvider,
      );

      await repository
          .approveRequest(
        classId,
        studentId,
      );

      await loadRequests(
        classId,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
      );
    }
  }

  Future<void> rejectRequest({
    required String classId,
    required String studentId,
  }) async {
    try {
      final repository = ref.read(
        classRepositoryProvider,
      );

      await repository
          .rejectRequest(
        classId,
        studentId,
      );

      await loadRequests(
        classId,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
      );
    }
  }
}

final joinRequestProvider =
    StateNotifierProvider<
      JoinRequestNotifier,
      JoinRequestState
    >((ref) {
      return JoinRequestNotifier(
        ref,
      );
    });