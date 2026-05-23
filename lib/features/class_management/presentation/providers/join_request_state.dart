import '../../domain/entities/join_request.dart';

class JoinRequestState {
  final List<JoinRequest> pendingRequests;
  final List<JoinRequest> processedRequests;
  final bool isLoading;
  final String? error;

  const JoinRequestState({
    this.pendingRequests = const [],
    this.processedRequests = const [],
    this.isLoading = false,
    this.error,
  });

  JoinRequestState copyWith({
    List<JoinRequest>? pendingRequests,
    List<JoinRequest>? processedRequests,
    bool? isLoading,
    String? error,
  }) {
    return JoinRequestState(
      pendingRequests:
          pendingRequests ??
          this.pendingRequests,
      processedRequests:
          processedRequests ??
          this.processedRequests,
      isLoading:
          isLoading ??
          this.isLoading,
      error: error,
    );
  }
}