import 'package:flutter/material.dart';
import '../domain/models/auth_role.dart';

// MOCK DATA for the ListBuilder
final List<AuthRole> mockRoles = [
  AuthRole(
    name: 'Instructor',
    description: 'Manage classes & attendance',
    icon: Icons.person_outline,
  ),
  AuthRole(
    name: 'Student',
    description: 'Join classes & view records',
    icon: Icons.school_outlined,
  ),
];