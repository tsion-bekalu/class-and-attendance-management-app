import 'package:flutter/material.dart';

class AuthRole {
  final String name;
  final String description;
  final IconData icon;

  AuthRole({required this.name, required this.description, required this.icon});
}

// MOCK DATA for the ListBuilder
final List<AuthRole> mockRoles = [
  AuthRole(name: 'Instructor', description: 'Manage classes & attendance', icon: Icons.school_outlined),
  AuthRole(name: 'Student', description: 'Join classes & view records', icon: Icons.person_outline),
];