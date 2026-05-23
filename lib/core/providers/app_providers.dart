// lib/core/providers/app_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

// Auth
import 'package:app/features/auth/data/mock_auth_service.dart';
import 'package:app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:app/features/auth/domain/repositories/auth_repository.dart';
import 'package:app/features/auth/domain/models/auth_response.dart';

// Class Management
import 'package:app/features/class_management/data/class_repository_impl.dart';
import 'package:app/features/class_management/domain/repositories/class_repository.dart';

// -----------------------------------------------------------------------------
// DEPENDENCY INJECTION
// -----------------------------------------------------------------------------

final authServiceProvider = Provider<MockAuthService>((ref) {
  return MockAuthService();
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl();
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

// Auth State Notifiers
class AuthStateNotifier extends Notifier<AsyncValue<AuthResponse?>> {
  @override
  AsyncValue<AuthResponse?> build() => const AsyncValue.data(null);

  Future<void> login(String email, String password, String role) async {
    state = const AsyncValue.loading();
    try {
      final authRepo = ref.read(authRepositoryProvider);
      final response = await authRepo.login(email, password, role);
      state = AsyncValue.data(response);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> register(
    String name,
    String email,
    String password,
    String confirmPassword,
    String role,
  ) async {
    state = const AsyncValue.loading();
    try {
      final authRepo = ref.read(authRepositoryProvider);
      final response = await authRepo.register(name, email, password, confirmPassword, role);
      state = AsyncValue.data(response);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> logout() async {
    try {
      final authRepo = ref.read(authRepositoryProvider);
      await authRepo.logout();
      ref.read(isAuthenticatedProvider.notifier).set(false);
      ref.read(userRoleProvider.notifier).set(null);
      ref.read(currentUserProvider.notifier).set(null);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteAccount() async {
    try {
      final authRepo = ref.read(authRepositoryProvider);
      await authRepo.deleteAccount();
      ref.read(isAuthenticatedProvider.notifier).set(false);
      ref.read(userRoleProvider.notifier).set(null);
      ref.read(currentUserProvider.notifier).set(null);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> checkAuthStatus() async {
    try {
      final authRepo = ref.read(authRepositoryProvider);
      final session = await authRepo.getCachedSession();
      state = AsyncValue.data(session);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final authStateProvider = NotifierProvider<AuthStateNotifier, AsyncValue<AuthResponse?>>(() {
  return AuthStateNotifier();
});