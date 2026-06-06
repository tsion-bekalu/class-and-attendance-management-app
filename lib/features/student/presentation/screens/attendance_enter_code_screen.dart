// features/student/presentation/screens/attendance_enter_code_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/models/student_models.dart';
import '../providers/student_providers.dart';
import 'attendance_marked_screen.dart'; // Add this import

class EnterCodeScreen extends ConsumerStatefulWidget {
  final String classId;

  const EnterCodeScreen({super.key, required this.classId});

  @override
  ConsumerState<EnterCodeScreen> createState() => _EnterCodeScreenState();
}

class _EnterCodeScreenState extends ConsumerState<EnterCodeScreen> {
  final _controller = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final code = _controller.text.trim().toUpperCase();
    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the session code.')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));

    final isPresent = true;
    final currentTime = DateTime.now();
    final formattedTime = '${currentTime.hour > 12 ? currentTime.hour - 12 : currentTime.hour}:${currentTime.minute.toString().padLeft(2, '0')} ${currentTime.hour >= 12 ? 'PM' : 'AM'}';

    // Get class name from UI provider
    String className = 'Class';
    final classesState = ref.read(uiStudentClassesProvider);
    classesState.whenData((classes) {
      final found = classes.firstWhere(
            (c) => c.id == widget.classId,
        orElse: () => StudentClass(
          id: '',
          name: 'Class',
          courseCode: '',
          instructorName: '',
          attendancePercentage: 0,
          presentSessions: 0,
          totalSessions: 0,
          schedule: '',
          instructorId: '',
          roomNumber: 'TBD',
        ),
      );
      className = found.name;
    });

    setState(() {
      _isSubmitting = false;
    });

    if (mounted) {
      // Option 1: Use push with MaterialPageRoute (most reliable)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AttendanceMarkedScreen(
            isPresent: isPresent,
            className: className,
            sessionTime: formattedTime,
            classId: widget.classId,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF155DFC)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Back',
          style: TextStyle(
              color: Color(0xFF155DFC),
              fontSize: 16,
              fontWeight: FontWeight.w500),
        ),
        titleSpacing: 0,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Enter Code',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1C2433)),
              ),
            ),
            const Divider(thickness: 1, color: Color(0xFFF1F4F9)),
            const Spacer(),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFFE8EFFF),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.keyboard_alt_outlined,
                  size: 40, color: Color(0xFF155DFC)),
            ),
            const SizedBox(height: 32),
            const Text(
              'Enter Session Code',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1C2433)),
            ),
            const SizedBox(height: 12),
            const Text(
              'Enter the code provided by your instructor',
              style: TextStyle(color: Colors.black54, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),

            // Code Input
            TextField(
              controller: _controller,
              textAlign: TextAlign.center,
              textCapitalization: TextCapitalization.characters,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w600,
                letterSpacing: 12,
                color: Color(0xFF1C2433),
              ),
              decoration: const InputDecoration(
                hintText: 'XXXXXX',
                hintStyle: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 12,
                  color: Colors.grey,
                ),
                border: InputBorder.none,
              ),
              maxLength: 8,
              buildCounter: (_, {required currentLength, required isFocused, maxLength}) =>
              null,
            ),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF155DFC),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: _isSubmitting
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child:
                  CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                )
                    : const Text(
                  'Submit Attendance',
                  style:
                  TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}