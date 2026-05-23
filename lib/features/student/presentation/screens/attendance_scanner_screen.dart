// features/student/presentation/screens/attendance_scanner_screen.dart
//
// NOTE: This screen uses mobile_scanner for real QR scanning.
// Add to pubspec.yaml:   mobile_scanner: ^5.0.0
//
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../providers/student_providers.dart';

class AttendanceScannerScreen extends ConsumerStatefulWidget {
  final String classId;

  const AttendanceScannerScreen({super.key, required this.classId});

  @override
  ConsumerState<AttendanceScannerScreen> createState() =>
      _AttendanceScannerScreenState();
}

class _AttendanceScannerScreenState
    extends ConsumerState<AttendanceScannerScreen> {
  final MobileScannerController _scannerController = MobileScannerController();
  bool _processed = false;

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_processed) return;
    final barcode = capture.barcodes.firstOrNull;
    if (barcode?.rawValue == null) return;

    _processed = true;
    _scannerController.stop();

    final qrData = barcode!.rawValue!;

    await ref
        .read(attendanceSubmissionProvider.notifier)
        .submitByQr(widget.classId, qrData);

    final state = ref.read(attendanceSubmissionProvider);

    if (!mounted) return;

    state.whenData((result) {
      if (result != null) {
        context.goNamed(
          'attendance-marked',
          queryParameters: {
            'isPresent': result.isPresent.toString(),
            'className': result.className ?? '',
            'sessionTime': result.sessionTime ?? '',
          },
        );
      }
    });

    if (state.hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${state.error}')),
      );
      setState(() => _processed = false);
      _scannerController.start();
    }
  }

  @override
  Widget build(BuildContext context) {
    final submissionState = ref.watch(attendanceSubmissionProvider);
    final isLoading = submissionState.isLoading;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Camera feed
            MobileScanner(
              controller: _scannerController,
              onDetect: _onDetect,
            ),

            // Overlay UI
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(flex: 2),

                Center(
                  child: Container(
                    width: 280,
                    height: 280,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFFA6C1FF),
                        width: 4,
                      ),
                      borderRadius: BorderRadius.circular(32),
                      color: Colors.white.withValues(alpha: 0.05),
                    ),
                    child: isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                                color: Color(0xFF155DFC)))
                        : const SizedBox.shrink(),
                  ),
                ),

                const SizedBox(height: 48),

                const Text(
                  'Scanning QR Code...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Position QR code within the frame',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 48),

                SizedBox(
                  width: 120,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFF2C2C2E),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
                const Spacer(flex: 3),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
