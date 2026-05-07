// lib/features/class_management/data/class_local_storage.dart
class ClassLocalStorage {
  static final List<Map<String, dynamic>> _classes = [];

  static void addClass(Map<String, dynamic> classData) {
    _classes.add(classData);
  }

  static Map<String, dynamic>? getClassById(String id) {
    try {
      return _classes.firstWhere((c) => c['id'] == id);
    } catch (_) {
      return null;
    }
  }

  static void deleteClass(String id) {
    _classes.removeWhere((c) => c['id'] == id);
  }

  static List<Map<String, dynamic>> getAllClasses() {
    return _classes;
  }
}
