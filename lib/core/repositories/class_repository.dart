import 'package:attendance_app/core/database/dao/class_dao.dart';
import 'package:attendance_app/core/database/dao/enrolled_student_dao.dart';
import 'package:attendance_app/core/models/class_model.dart';
import 'base_repository.dart';

class ClassRepository extends BaseRepository {
  final ClassDao _classDao = ClassDao();
  final EnrolledStudentDao _enrolledStudentDao = EnrolledStudentDao();
  
  @override
  String get tableName => 'classes';
  
  @override
  Duration get cacheTTL => const Duration(minutes: 10);

  Future<List<Class>> getClassesByInstructor(String instructorId, 
      {bool forceRefresh = false}) async {
    return await handleListCacheMiss(
      fetchFromApi: () async {
        // TODO: Replace with actual API call
        return <Class>[];
      },
      cacheData: (classes) async {
        for (var classObj in classes) {
          await _classDao.insertClass(classObj, 'Instructor Name');
        }
      },
      getFromCache: () async {
        return await _classDao.getClassesByInstructor(instructorId);
      },
      forceRefresh: forceRefresh,
    );
  }

  Future<List<Class>> getEnrolledClasses(String studentId,
      {bool forceRefresh = false}) async {
    return await handleListCacheMiss(
      fetchFromApi: () async {
        // TODO: Replace with actual API call
        return <Class>[];
      },
      cacheData: (classes) async {
        for (var classObj in classes) {
          await _classDao.insertClass(classObj, '');
        }
      },
      getFromCache: () async {
        return await _classDao.getEnrolledClassesByStudent(studentId);
      },
      forceRefresh: forceRefresh,
    );
  }

  Future<Class?> getClassById(String classId, {bool forceRefresh = false}) async {
    if (!forceRefresh) {
      final cached = await _classDao.getClassById(classId);
      if (cached != null && await isCacheValid()) {
        return cached;
      }
    }
    return await _classDao.getClassById(classId);
  }

  Future<Class?> getClassByJoinCode(String joinCode) async {
    return await _classDao.getClassByJoinCode(joinCode);
  }

  Future<void> createClass(Class classObj, String instructorName) async {
    await _classDao.insertClass(classObj, instructorName);
    await dbHelper.updateLastSyncTime(tableName);
  }

  Future<void> updateClass(Class classObj) async {
    await _classDao.updateClass(classObj);
    await dbHelper.updateLastSyncTime(tableName);
  }

  Future<void> deleteClass(String classId) async {
    await _classDao.deleteClass(classId);
    await invalidateCache();
  }

  Future<void> enrollStudent({
    required String studentId,
    required String studentName,
    required String studentEmail,
    required String classId,
    required String className,
  }) async {
    await _enrolledStudentDao.enrollStudent(
      studentId: studentId,
      studentName: studentName,
      studentEmail: studentEmail,
      classId: classId,
      className: className,
    );
    
    final newCount = await _enrolledStudentDao.getEnrolledCount(classId);
    await _classDao.updateEnrolledCount(classId, newCount);
  }

  Future<bool> isStudentEnrolled(String studentId, String classId) async {
    return await _enrolledStudentDao.isStudentEnrolled(studentId, classId);
  }
}