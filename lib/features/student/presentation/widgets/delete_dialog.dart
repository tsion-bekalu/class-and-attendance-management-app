// features/student/presentation/widgets/delete_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/student_providers.dart';

class DeleteDialog extends ConsumerStatefulWidget {
  const DeleteDialog({super.key});

  @override
  ConsumerState<DeleteDialog> createState() => _DeleteDialogState();
}

class _DeleteDialogState extends ConsumerState<DeleteDialog> {
  bool _isLoading = false;
  final TextEditingController _confirmController = TextEditingController();
  final String _confirmText = 'DELETE';

  @override
  void dispose() {
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _deleteAccount() async {
    if (_confirmController.text.trim().toUpperCase() != _confirmText) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please type DELETE to confirm'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Here you would call your API to delete the account
      // For example:
      // final auth = ref.read(authProvider);
      // if (auth.isLoggedIn) {
      //   await ref.read(studentApiServiceProvider).deleteAccount(
      //     auth.studentId!,
      //     auth.token!,
      //   );
      // }

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      // Clear authentication
      ref.read(authProvider.notifier).clearAuth();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account deleted successfully'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );

      if (!mounted) return;

      // Navigate to login/registration screen
      context.goNamed('register'); // or 'login' depending on your routes
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting account: $e'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Warning Icon
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.delete_forever_outlined,
                  size: 48,
                  color: Colors.red,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Title
            const Center(
              child: Text(
                'Delete Account',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1C1E),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Warning Message
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.withOpacity(0.2)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '⚠️ Warning: This action cannot be undone!',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Deleting your account will permanently remove:',
                    style: TextStyle(fontSize: 13, color: Color(0xFF42474E)),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '• Your profile information\n'
                    '• All attendance records\n'
                    '• Class enrollments\n'
                    '• Notification history\n'
                    '• All associated data',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF42474E),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Confirmation Text Field
            const Text(
              'Type "DELETE" to confirm',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1A1C1E),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _confirmController,
              enabled: !_isLoading,
              textCapitalization: TextCapitalization.characters,
              decoration: InputDecoration(
                hintText: 'DELETE',
                hintStyle: const TextStyle(
                  color: Color(0xFF8E9199),
                  fontWeight: FontWeight.w500,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.red, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Cancel Button
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

                // Delete Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _deleteAccount,
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
                            'Delete Permanently',
                            style: TextStyle(
                              fontSize: 14,
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
