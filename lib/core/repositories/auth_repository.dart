import 'package:attendance_app/core/database/dao/user_dao.dart';
import 'package:attendance_app/core/models/user.dart';
import 'base_repository.dart';

class AuthRepository extends BaseRepository {
  final UserDao _userDao = UserDao();
  
  @override
  String get tableName => 'users';
  
  @override
  Duration get cacheTTL => const Duration(hours: 24);

  Future<User?> getCachedUser() async {
    return await _userDao.getLoggedInUser();
  }

  Future<User> fetchAndCacheUser(String email, String password) async {
    // Simple approach without complex cache strategy
    final cachedUser = await getCachedUser();
    
    if (cachedUser != null && await isCacheValid()) {
      return cachedUser; // Cache HIT
    }
    
    // Cache MISS - fetch from API
    // TODO: Replace with actual API call
    final freshUser = User(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: email.split('@').first,
      email: email,
      role: UserRole.student,
    );
    
    await _userDao.insertUser(freshUser);
    await dbHelper.updateLastSyncTime(tableName);
    return freshUser;
  }

  Future<bool> isLoggedIn() async {
    final user = await getCachedUser();
    return user != null;
  }

  Future<void> cacheUser(User user, {String? token}) async {
    await _userDao.insertUser(user, token: token);
    await dbHelper.updateLastSyncTime(tableName);
  }

  Future<void> logout() async {
    await _userDao.logoutUser();
    await invalidateCache();
  }
}