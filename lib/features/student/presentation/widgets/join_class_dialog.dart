// features/student/presentation/widgets/join_class_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/student_providers.dart';

class JoinClassDialog extends ConsumerStatefulWidget {
  const JoinClassDialog({super.key});

  @override
  ConsumerState<JoinClassDialog> createState() => _JoinClassDialogState();
}

class _JoinClassDialogState extends ConsumerState<JoinClassDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _join() async {
    final code = _controller.text.trim().toUpperCase();
    if (code.isEmpty) return;

    await ref.read(joinClassProvider.notifier).joinClass(code);

    final state = ref.read(joinClassProvider);
    if (!mounted) return;

    if (state.hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not join class: ${state.error}'),
          backgroundColor: Colors.red,
        ),
      );
    } else if (!state.isLoading) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Successfully joined class!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final joinState = ref.watch(joinClassProvider);
    final isLoading = joinState.isLoading;

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        width: 400,
        padding: const EdgeInsets.fromLTRB(28, 28, 28, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Join Class',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1C1E)),
            ),
            const SizedBox(height: 12),
            const Text(
              'Enter the class code provided by your instructor',
              style: TextStyle(
                  fontSize: 16, color: Color(0xFF42474E), height: 1.4),
            ),
            const SizedBox(height: 28),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF1F4F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _controller,
                textCapitalization: TextCapitalization.characters,
                enabled: !isLoading,
                decoration: const InputDecoration(
                  hintText: 'CLASS-CODE',
                  hintStyle: TextStyle(
                      color: Color(0xFF8E9199), fontWeight: FontWeight.w500),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5),
              ),
            ),
            const SizedBox(height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: isLoading ? null : () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 14),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF42474E)),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: isLoading ? null : _join,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E6AFB),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 28, vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2),
                        )
                      : const Text('Join',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
