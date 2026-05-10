import 'package:flutter/material.dart';

class TimetableEntry {
  final String day; // Ensure this is here
  final String title;
  final String courseCode;
  final String time;
  final String location;
  final String duration;
  final Color accentColor;

  TimetableEntry({
    required this.day,
    required this.title,
    required this.courseCode,
    required this.time,
    required this.location,
    required this.duration,
    required this.accentColor,
  });
}