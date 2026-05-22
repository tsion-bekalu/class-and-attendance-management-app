# Member 1 - Quick Start Checklist

## ✅ What's Been Done
- [x] SQLite dependencies added to pubspec.yaml
- [x] Database helper created with auth cache tables
- [x] Auth models (AuthResponse, LoginRequest, RegisterRequest) created
- [x] AuthLocalDataSource for SQLite cache operations
- [x] AuthRemoteDataSource for API calls (mock data - ready to replace)
- [x] AuthRepository interface defined
- [x] AuthRepositoryImpl with cache-first pattern implemented
- [x] Auth providers added to core providers
- [x] Login screen updated (uses AppTheme + Riverpod)
- [x] Register screen updated (uses AppTheme + Riverpod)
- [x] Role selection screen updated (uses AppTheme + Riverpod)
- [x] Splash screen updated with auth check logic

## 🚀 What You Need to Do Now

### Step 1: Run `flutter pub get`
```bash
flutter pub get
```
This will install the new SQLite dependencies.

### Step 2: Build and Test
```bash
flutter run
```

### Step 3: Test the Flow
1. **Start App** → Should show splash screen with loading
2. **Select Role** → Choose "instructor" or "student"
3. **Login** → Enter any email/password (mock accepts all)
4. **Dashboard** → Should navigate to correct dashboard
5. **Verify Cache** → Restart app, should skip login

### Step 4: Integration Points for Team
- **Member 2**: Access current user role via `ref.watch(userRoleProvider)`
- **Member 3**: Check if student via `ref.watch(isStudentProvider)`
- **Member 5**: Add logout button that calls `authStateProvider.logout()`

### Step 5: When Real API is Ready
Replace mock data in `auth_remote_datasource.dart`:
```dart
// Add http/dio package to pubspec.yaml
// Then replace the mock implementation with real API calls
```

## 📁 File Locations Reference

| What | File |
|------|------|
| Database Setup | `lib/core/database/database_helper.dart` |
| Auth Models | `lib/features/auth/domain/models/auth_response.dart` |
| Local Cache | `lib/features/auth/data/datasources/auth_local_datasource.dart` |
| API Calls | `lib/features/auth/data/datasources/auth_remote_datasource.dart` |
| Repository | `lib/features/auth/data/repositories/auth_repository_impl.dart` |
| Providers | `lib/core/providers/app_providers.dart` |
| Login Screen | `lib/features/auth/presentation/screens/login.dart` |
| Register Screen | `lib/features/auth/presentation/screens/register.dart` |
| Role Selection | `lib/features/auth/presentation/screens/role_selection.dart` |
| Splash Screen | `lib/features/auth/presentation/screens/splash.dart` |

## 🎯 Key Concepts to Remember

1. **Cache-First Pattern**: Always check SQLite first before making API calls
2. **Global State**: Use `userRoleProvider` and `isAuthenticatedProvider` across app
3. **Async Values**: Login/register return `AsyncValue<AuthResponse?>` to show loading/error
4. **Session Persistence**: Tokens stored in SQLite, loaded on app restart
5. **Role-Based Navigation**: Use `isInstructorProvider` and `isStudentProvider` for routing

## ❓ Common Questions

**Q: Where is the user data stored?**
A: In SQLite tables (auth_session, auth_tokens, user_preferences) in `lib/core/database/database_helper.dart`

**Q: How do I add a logout button?**
A: Call `ref.read(authStateProvider.notifier).logout()` - it will clear cache and return to role selection

**Q: How do I check if user is logged in?**
A: Watch the provider: `ref.watch(isAuthenticatedProvider)` - returns boolean

**Q: How do I get the current user's role?**
A: `final role = ref.watch(userRoleProvider)` - returns 'instructor' or 'student'

**Q: How do I switch to real API?**
A: Edit `auth_remote_datasource.dart` and replace mock data with HTTP client calls

---

**You're all set! 🚀 Your Member 1 implementation is complete and ready for testing!**
