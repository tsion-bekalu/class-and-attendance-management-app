// features/student/data/student_api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

/// Thin wrapper around the REST API.
/// Replace [baseUrl] with your actual server address.
class StudentApiService {
  final String baseUrl;
  final http.Client _client;

  StudentApiService({
    this.baseUrl = 'https://api.yourapp.com/v1',
    http.Client? client,
  }) : _client = client ?? http.Client();

  // ── Auth header helper ────────────────────────────────────────────────────

  Map<String, String> _headers(String token) => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

  // ── Student profile ───────────────────────────────────────────────────────

  Future<Map<String, dynamic>> fetchStudentProfile(
      String studentId, String token) async {
    final res = await _client.get(
      Uri.parse('$baseUrl/students/$studentId'),
      headers: _headers(token),
    );
    _checkStatus(res);
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  // ── Classes ───────────────────────────────────────────────────────────────

  Future<List<Map<String, dynamic>>> fetchStudentClasses(
      String studentId, String token) async {
    final res = await _client.get(
      Uri.parse('$baseUrl/students/$studentId/classes'),
      headers: _headers(token),
    );
    _checkStatus(res);
    return List<Map<String, dynamic>>.from(jsonDecode(res.body) as List);
  }

  Future<Map<String, dynamic>> joinClass(
      String classCode, String studentId, String token) async {
    final res = await _client.post(
      Uri.parse('$baseUrl/classes/join'),
      headers: _headers(token),
      body: jsonEncode({'code': classCode, 'studentId': studentId}),
    );
    _checkStatus(res);
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  // ── Attendance ────────────────────────────────────────────────────────────

  Future<List<Map<String, dynamic>>> fetchAttendanceHistory(
      String classId, String studentId, String token) async {
    final res = await _client.get(
      Uri.parse('$baseUrl/classes/$classId/attendance/$studentId'),
      headers: _headers(token),
    );
    _checkStatus(res);
    return List<Map<String, dynamic>>.from(jsonDecode(res.body) as List);
  }

  /// Submit attendance via manual code.
  Future<Map<String, dynamic>> submitAttendanceCode(
      String classId, String code, String studentId, String token) async {
    final res = await _client.post(
      Uri.parse('$baseUrl/classes/$classId/attendance/submit'),
      headers: _headers(token),
      body: jsonEncode({'code': code, 'studentId': studentId, 'method': 'manual'}),
    );
    _checkStatus(res);
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  /// Submit attendance via QR scan payload.
  Future<Map<String, dynamic>> submitAttendanceQr(
      String classId, String qrData, String studentId, String token) async {
    final res = await _client.post(
      Uri.parse('$baseUrl/classes/$classId/attendance/submit'),
      headers: _headers(token),
      body: jsonEncode({'qrData': qrData, 'studentId': studentId, 'method': 'qr'}),
    );
    _checkStatus(res);
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  // ── Timetable ─────────────────────────────────────────────────────────────

  Future<List<Map<String, dynamic>>> fetchTimetable(
      String studentId, String token) async {
    final res = await _client.get(
      Uri.parse('$baseUrl/students/$studentId/timetable'),
      headers: _headers(token),
    );
    _checkStatus(res);
    return List<Map<String, dynamic>>.from(jsonDecode(res.body) as List);
  }

  // ── Notifications ─────────────────────────────────────────────────────────

  Future<List<Map<String, dynamic>>> fetchNotifications(
      String studentId, String token) async {
    final res = await _client.get(
      Uri.parse('$baseUrl/students/$studentId/notifications'),
      headers: _headers(token),
    );
    _checkStatus(res);
    return List<Map<String, dynamic>>.from(jsonDecode(res.body) as List);
  }

  // ── Announcements ─────────────────────────────────────────────────────────

  Future<List<Map<String, dynamic>>> fetchAnnouncements(
      String classId, String token) async {
    final res = await _client.get(
      Uri.parse('$baseUrl/classes/$classId/announcements'),
      headers: _headers(token),
    );
    _checkStatus(res);
    return List<Map<String, dynamic>>.from(jsonDecode(res.body) as List);
  }

  // ── Utility ───────────────────────────────────────────────────────────────

  void _checkStatus(http.Response res) {
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw ApiException(res.statusCode, res.body);
    }
  }
}

class ApiException implements Exception {
  final int statusCode;
  final String body;
  ApiException(this.statusCode, this.body);

  @override
  String toString() => 'ApiException($statusCode): $body';
}
