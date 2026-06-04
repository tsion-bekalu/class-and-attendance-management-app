import 'dart:math';

String generateSessionCode() {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';

  final random = Random();

  return List.generate(
    8,
    (_) => chars[random.nextInt(chars.length)],
  ).join();
}