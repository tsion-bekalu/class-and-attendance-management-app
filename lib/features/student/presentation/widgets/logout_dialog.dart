// features/student/presentation/widgets/logout_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/student_providers.dart';

class LogoutDialog extends ConsumerStatefulWidget {
  const LogoutDialog({super.key});

  @override
  ConsumerState<LogoutDialog> createState() => _LogoutDialogState();
}

class _LogoutDialogState extends ConsumerState<LogoutDialog> {
  bool _isLoading = false;

  Future<void> _logout() async {
    setState(() => _isLoading = true);

    // Simulate a small delay for better UX
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    // Clear authentication state
    ref.read(authProvider.notifier).clearAuth();

    // Navigate to login screen (adjust route name as needed)
    context.goNamed('login');

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Logged out successfully'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Warning Icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.logout_outlined,
                size: 48,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 24),

            // Title
            const Text(
              'Logout',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1C1E),
              ),
            ),
            const SizedBox(height: 12),

            // Message
            const Text(
              'Are you sure you want to logout?',
              style: TextStyle(fontSize: 16, color: Color(0xFF42474E)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: _isLoading ? null : () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: Color(0xFFE0E0E0)),
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF42474E),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Logout Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _logout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Logout',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
