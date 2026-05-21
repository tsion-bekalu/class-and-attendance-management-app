import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'database_helper.dart';

final databaseHelperProvider = Provider<DatabaseHelper>((ref) {
  return DatabaseHelper();
});

final isCacheEmptyProvider = FutureProvider<bool>((ref) async {
  final dbHelper = ref.read(databaseHelperProvider);
  final userCount = await dbHelper.getTableCount('users');
  final classCount = await dbHelper.getTableCount('classes');
  return userCount == 0 && classCount == 0;
});

final lastSyncTimeProvider = StateProvider<DateTime?>((ref) => null);