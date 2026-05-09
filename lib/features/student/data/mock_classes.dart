import '../../../../core/models/class_model.dart';
import 'package:flutter/material.dart';


final List<Class> mockClasses = [
    Class(
      id: '1',
      name: 'Data Structures & Algorithms',
      joinCode: 'CS301',
      instructorId: 'Dr. Sarah Johnson',
      enrolledStudentIds: [],
      status: ClassStatus.active,
      day: 'Today',
      startTime: const TimeOfDay(hour: 14, minute: 0),
      endTime: const TimeOfDay(hour: 15, minute: 30),
    ),
    Class(
      id: '2',
      name: 'Database Management Systems',
      joinCode: 'CS305',
      instructorId: 'Prof. Michael Chen',
      enrolledStudentIds: [],
      status: ClassStatus.active,
      day: 'Tomorrow',
      startTime: const TimeOfDay(hour: 10, minute: 0),
      endTime: const TimeOfDay(hour: 11, minute: 30),
    ),
  ];
