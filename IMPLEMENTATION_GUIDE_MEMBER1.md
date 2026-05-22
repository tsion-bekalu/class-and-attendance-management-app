# Member 1: Authentication & Authorization - Complete Implementation Guide

## ✅ COMPLETED IMPLEMENTATION

### 1. **SQLite Setup** ✅
- **File**: `lib/core/database/database_helper.dart`
- **What it does**: Manages SQLite database initialization and provides generic cache operations
- **Tables created**:
  - `auth_session`: Stores user session data (userId, email, name, role, tokens, timestamps)
  - `auth_tokens`: Stores access/refresh tokens separately
  - `user_preferences`: Stores user preferences (role selection, theme, remember me flag)

### 2. **Auth Models** ✅
- **File**: `lib/features/auth/domain/models/auth_response.dart`
- **Models**:
  - `AuthResponse`: Represents authenticated user data and tokens
  - `LoginRequest`: Login form data (email, password, role)
  - `RegisterRequest`: Registration form data (name, email, password, role)

### 3. **Auth Local Data Source** ✅
- **File**: `lib/features/auth/data/datasources/auth_local_datasource.dart`
- **Responsibilities**:
  - Cache user session after login/register → `cacheAuthSession()`
  - Retrieve cached auth session → `getCachedAuthSession()`
  - Get cached access token → `getCachedAccessToken()`
  - Get cached user role → `getCachedUserRole()`
  - Check if user is authenticated → `isUserAuthenticated()`
  - Clear all auth cache on logout → `clearAuthCache()`
  - Manage user preferences

### 4. **Auth Remote Data Source** ✅
- **File**: `lib/features/auth/data/datasources/auth_remote_datasource.dart`
- **Methods** (currently mock, replace with actual HTTP client):
  - `login()`: API call for user login
  - `register()`: API call for user registration
  - `refreshToken()`: Refresh expired access tokens
  - `logout()`: Notify server of logout
  - `verifyToken()`: Verify if token is still valid
- **Note**: Uses mock data for now - replace with actual HTTP client (http/dio package)

### 5. **Auth Repository Interface** ✅
- **File**: `lib/features/auth/domain/repositories/auth_repository.dart`
- **Defines contract for**:
  - Login and registration
  - Session management
  - Token refresh
  - Authentication status checking
  - Role retrieval

### 6. **Auth Repository Implementation (Cache-First Pattern)** ✅
- **File**: `lib/features/auth/data/repositories/auth_repository_impl.dart`
- **Implements cache-first strategy**:
  1. `login()`: Tries network → caches response on success → falls back to cache on error
  2. `register()`: Network only (no cached registration)
  3. `isAuthenticated()`: Checks local cache first, optionally verifies with server
  4. `getCachedSession()`: Returns cached session (cache hit)
  5. `getUserRole()`: Gets role from local cache
  6. `logout()`: Clears all local cache

### 7. **Riverpod Providers** ✅
- **File**: `lib/core/providers/app_providers.dart`
- **Added**:
  - `authRepositoryProvider`: Dependency injection for auth repository
  - `AuthStateNotifier`: Manages auth state (login, register, logout, checkAuthStatus)
  - `authStateProvider`: Provides auth state across app
- **Existing providers** (already in place):
  - `globalLoadingProvider`: Global loading state
  - `isAuthenticatedProvider`: Authentication status
  - `userRoleProvider`: Current user's role
  - `currentUserProvider`: Current user data
  - `isInstructorProvider`: Derived provider to check if user is instructor
  - `isStudentProvider`: Derived provider to check if user is student

### 8. **Login Screen** ✅
- **File**: `lib/features/auth/presentation/screens/login.dart`
- **Features**:
  - Uses Riverpod with `ConsumerStatefulWidget`
  - Form validation (email, password)
  - Uses `AppTheme` for consistent styling
  - Shows loading state and error messages
  - Calls `authStateProvider.login()` which handles cache-first logic
  - Updates global state on successful login
  - Routes to appropriate dashboard based on role

### 9. **Register Screen** ✅
- **File**: `lib/features/auth/presentation/screens/register.dart`
- **Features**:
  - Uses Riverpod with `ConsumerStatefulWidget`
  - Form validation (name, email, password, confirm password)
  - Uses `AppTheme` for consistent styling
  - Shows loading and error states
  - Calls `authStateProvider.register()` 
  - Updates global state on successful registration
  - Routes to appropriate dashboard based on role

### 10. **Role Selection Screen** ✅
- **File**: `lib/features/auth/presentation/screens/role_selection.dart`
- **Features**:
  - Allows user to select between "instructor" or "student" role
  - Uses `AppTheme` primary color for consistency
  - Stores selected role in `selectedRoleProvider`
  - Routes to login screen with selected role

### 11. **Splash Screen** ✅
- **File**: `lib/features/auth/presentation/screens/splash.dart`
- **Features**:
  - Calls `authStateProvider.checkAuthStatus()` to load cached session
  - If authenticated: Routes to appropriate dashboard (instructor or student)
  - If not authenticated: Routes to role selection screen
  - Shows loading indicator during initialization
  - Uses `AppTheme` colors

---

## 📊 DATA FLOW DIAGRAM

```
Splash Screen (App Start)
    ↓
Check Auth Status
    ├─ Session Found → Load User Data → Go to Dashboard
    └─ No Session → Go to Role Selection
         ↓
    Role Selection
         ↓
    Login/Register Screen
         ↓
    Local Cache Miss → Network Request
    (AuthRepositoryImpl.login/register)
         ↓
    Success → Cache in SQLite
         ↓
    Update Global State
         ↓
    Navigate to Dashboard
```

---

## 🔄 Cache-First Pattern Implementation

### Login Flow:
1. User enters email/password → Login screen calls `authStateProvider.login()`
2. `AuthRepositoryImpl.login()` makes network request
3. On success: `AuthLocalDataSource.cacheAuthSession()` stores user + tokens in SQLite
4. Global providers updated: `isAuthenticatedProvider`, `userRoleProvider`, `currentUserProvider`
5. Navigate to dashboard

### Session Check Flow (Splash):
1. App starts → Splash calls `authStateProvider.checkAuthStatus()`
2. `AuthRepositoryImpl.getCachedSession()` checks SQLite (cache hit)
3. If found: Load user data and route to dashboard
4. If not found: Route to role selection

### Logout Flow:
1. User logs out → `authStateProvider.logout()`
2. `AuthRepositoryImpl.logout()` calls `AuthLocalDataSource.clearAuthCache()`
3. All SQLite auth tables are cleared
4. Global state reset
5. Route to role selection

---

## 🛠️ HOW TO REPLACE MOCK DATA WITH REAL API

### In `lib/features/auth/data/datasources/auth_remote_datasource.dart`:

**Current (Mock):**
```dart
Future<AuthResponse> login(LoginRequest request) async {
  await _delay();
  // Mock data
  return AuthResponse(...);
}
```

**Replace with actual HTTP client (Dio or http package):**
```dart
import 'package:dio/dio.dart';

class AuthRemoteDataSource {
  final Dio _dio = Dio();
  
  Future<AuthResponse> login(LoginRequest request) async {
    try {
      final response = await _dio.post(
        'https://your-api.com/api/auth/login',
        data: request.toJson(),
      );
      return AuthResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }
}
```

---

## ✨ AUTHORIZATION RULES (Student vs Instructor)

### In Global Providers:
```dart
// Check if user is instructor
final isInstructorProvider = Provider<bool>((ref) {
  final role = ref.watch(userRoleProvider);
  return role?.toLowerCase() == 'instructor';
});

// Check if user is student
final isStudentProvider = Provider<bool>((ref) {
  final role = ref.watch(userRoleProvider);
  return role?.toLowerCase() == 'student';
});
```

### In Routing (protected routes):
You can use these providers in your routing to guard routes:
```dart
// Example in Member 5's routing implementation
if (ref.watch(isInstructorProvider)) {
  // Show instructor routes
} else if (ref.watch(isStudentProvider)) {
  // Show student routes
}
```

---

## 📱 TESTING YOUR IMPLEMENTATION

### Test Login:
1. Start app → Splash screen
2. Click Continue → Role Selection
3. Select "Instructor" → Login screen
4. Enter any email/password → Login button
5. Should cache data and route to `/instructor/dashboard`
6. Check: User role shows in app state

### Test Session Persistence:
1. Complete login
2. Restart app
3. Should skip role selection and login screens
4. Should go directly to dashboard (session cached)

### Test Logout:
1. From dashboard, logout (implement logout button using `authStateProvider.logout()`)
2. Should clear cache and route to role selection

---

## 🔑 KEY FILES CREATED/MODIFIED

```
✅ lib/core/database/database_helper.dart                     [NEW]
✅ lib/features/auth/domain/models/auth_response.dart         [NEW]
✅ lib/features/auth/data/datasources/auth_local_datasource.dart  [NEW]
✅ lib/features/auth/data/datasources/auth_remote_datasource.dart [NEW]
✅ lib/features/auth/domain/repositories/auth_repository.dart [NEW]
✅ lib/features/auth/data/repositories/auth_repository_impl.dart  [NEW]
✅ lib/core/providers/app_providers.dart                       [UPDATED]
✅ lib/features/auth/presentation/screens/login.dart          [UPDATED]
✅ lib/features/auth/presentation/screens/register.dart       [UPDATED]
✅ lib/features/auth/presentation/screens/role_selection.dart [UPDATED]
✅ lib/features/auth/presentation/screens/splash.dart         [UPDATED]
✅ pubspec.yaml                                                [UPDATED - Added sqflite, path, path_provider]
```

---

## 🎯 NEXT STEPS FOR YOUR TEAM

1. **Member 2 (Class Management)**: Use the auth providers to get current user role:
   ```dart
   final isInstructor = ref.watch(isInstructorProvider);
   final userRole = ref.watch(userRoleProvider);
   ```

2. **Member 3 (Student Module)**: Filter student data using `isStudentProvider`

3. **Member 5 (Integration)**: 
   - Add protected routes using role-based navigation
   - Implement logout functionality in dashboards
   - Add app bar with user info and logout button

---

## 📝 NOTES

- **Authentication State**: Persisted in SQLite cache
- **Session Duration**: Set to 7 days (modify in `auth_remote_datasource.dart`)
- **Theme**: Using `AppTheme` from `core/theme/app_theme.dart`
- **State Management**: Riverpod 3 with `AsyncValue` for loading states
- **Error Handling**: Try-catch with fallback to cached data when network fails

