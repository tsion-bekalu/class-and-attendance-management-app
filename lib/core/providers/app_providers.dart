// lib/core/providers/app_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

// Auth
import 'package:app/features/auth/data/mock_auth_service.dart';

// Class Management
import 'package:app/features/class_management/data/class_repository_impl.dart';
import 'package:app/features/class_management/domain/repositories/class_repository.dart';

// -----------------------------------------------------------------------------
// DEPENDENCY INJECTION
// -----------------------------------------------------------------------------

final authServiceProvider = Provider<MockAuthService>((ref) {
  return MockAuthService();
});

final classRepositoryProvider = Provider<ClassRepository>((ref) {
  return ClassRepositoryImpl();
});

// -----------------------------------------------------------------------------
// SIMPLE GLOBAL STATE USING NOTIFIERS
// -----------------------------------------------------------------------------

class BoolNotifier extends Notifier<bool> {
  BoolNotifier(this.initialValue);

  final bool initialValue;

  @override
  bool build() => initialValue;

  void set(bool value) => state = value;
}

class StringNotifier extends Notifier<String?> {
  StringNotifier(this.initialValue);

  final String? initialValue;

  @override
  String? build() => initialValue;

  void set(String? value) => state = value;
}

class DynamicNotifier extends Notifier<dynamic> {
  DynamicNotifier(this.initialValue);

  final dynamic initialValue;

  @override
  dynamic build() => initialValue;

  void set(dynamic value) => state = value;
}

// Global providers
final globalLoadingProvider =
    NotifierProvider<BoolNotifier, bool>(() => BoolNotifier(false));

final selectedRoleProvider =
    NotifierProvider<StringNotifier, String?>(() => StringNotifier(null));

final currentUserProvider =
    NotifierProvider<DynamicNotifier, dynamic>(() => DynamicNotifier(null));

final isAuthenticatedProvider =
    NotifierProvider<BoolNotifier, bool>(() => BoolNotifier(false));

final userRoleProvider =
    NotifierProvider<StringNotifier, String?>(() => StringNotifier(null));

// Derived providers
final isInstructorProvider = Provider<bool>((ref) {
  final role = ref.watch(userRoleProvider);
  return role?.toLowerCase() == 'instructor';
});

final isStudentProvider = Provider<bool>((ref) {
  final role = ref.watch(userRoleProvider);
  return role?.toLowerCase() == 'student';
});