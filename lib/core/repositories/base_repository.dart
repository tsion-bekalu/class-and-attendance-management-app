import 'package:attendance_app/core/database/database_helper.dart';

enum CacheStrategy {
  cacheFirst,
  networkFirst,
  cacheOnly,
  networkOnly,
}

abstract class BaseRepository {
  final DatabaseHelper dbHelper = DatabaseHelper();

  String get tableName;
  Duration get cacheTTL => const Duration(minutes: 5);

  Future<bool> isCacheAvailable() async {
    return !(await dbHelper.isTableEmpty(tableName));
  }

  Future<bool> isCacheFresh() async {
    final isStale = await dbHelper.isCacheStale(tableName, cacheTTL);
    return !isStale;
  }

  Future<bool> isCacheValid() async {
    return await isCacheAvailable() && await isCacheFresh();
  }

  Future<int?> getCacheAgeMinutes() async {
    final lastSync = await dbHelper.getLastSyncTime(tableName);
    if (lastSync == null) return null;
    return DateTime.now().difference(lastSync).inMinutes;
  }

  // Fixed: getFromCache returns Future<T?> for async cache retrieval
  Future<T> handleCacheWithStrategy<T>({
    required Future<T> Function() fetchFromApi,
    required Future<void> Function(T data) cacheData,
    required Future<T?> Function() getFromCache,  // Changed to Future
    CacheStrategy strategy = CacheStrategy.cacheFirst,
  }) async {
    switch (strategy) {
      case CacheStrategy.cacheFirst:
        final cached = await getFromCache();  // Now works with async
        if (cached != null && await isCacheValid()) {
          return cached;
        }
        final freshData = await fetchFromApi();
        await cacheData(freshData);
        await dbHelper.updateLastSyncTime(tableName);
        return freshData;

      case CacheStrategy.networkFirst:
        try {
          final freshData = await fetchFromApi();
          await cacheData(freshData);
          await dbHelper.updateLastSyncTime(tableName);
          return freshData;
        } catch (e) {
          final cached = await getFromCache();
          if (cached != null) return cached;
          rethrow;
        }

      case CacheStrategy.cacheOnly:
        final cached = await getFromCache();
        if (cached != null) return cached;
        throw Exception('Cache miss and cache-only strategy');

      case CacheStrategy.networkOnly:
        final freshData = await fetchFromApi();
        await cacheData(freshData);
        return freshData;
    }
  }

  // Fixed: getFromCache returns Future<List<T>>
  Future<List<T>> handleListCacheMiss<T>({
    required Future<List<T>> Function() fetchFromApi,
    required Future<void> Function(List<T> data) cacheData,
    required Future<List<T>> Function() getFromCache,
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh) {
      final cached = await getFromCache();
      if (cached.isNotEmpty && await isCacheValid()) {
        return cached;
      }
    }
    
    final freshData = await fetchFromApi();
    await cacheData(freshData);
    await dbHelper.updateLastSyncTime(tableName);
    return freshData;
  }

  Future<void> invalidateCache() async {
    await dbHelper.clearTable(tableName);
    await dbHelper.updateLastSyncTime(tableName);
  }

  Future<void> forceRefreshCache() async {
    await dbHelper.updateLastSyncTime(tableName);
  }
}