import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  String? _selectedRole;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F5FB),
      body: SafeArea(
        child: Column(
          children: [
            // TOP LOGO SECTION
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/logo3.png',
                      width: 150,
                      height: 150,
                    ),
                    
                  ],
                ),
              ),
            ),

            // WHITE CARD
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 34, 24, 30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(34),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.10),
                    blurRadius: 30,
                    offset: const Offset(0, -6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    'Join as',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1D2433),
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Select your role to continue',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF7B8190),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // INSTRUCTOR TILE
                  _RoleTile(
                    icon: Icons.school_outlined,
                    title: 'Instructor',
                    subtitle: 'Manage classes &\nattendance',
                    isSelected: _selectedRole == 'Instructor',
                    onTap: () =>
                        setState(() => _selectedRole = 'Instructor'),
                  ),

                  const SizedBox(height: 16),

                  // STUDENT TILE
                  _RoleTile(
                    icon: Icons.groups_outlined,
                    title: 'Student',
                    subtitle: 'Join classes & mark\nattendance',
                    isSelected: _selectedRole == 'Student',
                    onTap: () =>
                        setState(() => _selectedRole = 'Student'),
                  ),

                  const SizedBox(height: 30),

                  // BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2962FF),
                        elevation: 4,
                        shadowColor:
                            Colors.black.withValues(alpha: 0.25),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: _selectedRole == null
                          ? null
                          : () => context.push(
                                '/login',
                                extra: _selectedRole,
                              ),
                      child: const Text(
                        'Continue',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Text(
                    'By continuing, you agree to our Terms & Privacy Policy',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoleTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFF2F6FF)
              : const Color(0xFFFAFAFC),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF2962FF)
                : const Color(0xFFE7EAF0),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF2962FF)
                    : const Color(0xFFF1F3F7),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected
                    ? Colors.white
                    : const Color(0xFFB7BCC8),
                size: 24,
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? const Color(0xFF1D2433)
                          : const Color(0xFFC1C5D0),
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    subtitle,
                    style: TextStyle(
                      height: 1.4,
                      fontSize: 14,
                      color: isSelected
                          ? const Color(0xFF5E6573)
                          : const Color(0xFFC9CDD6),
                    ),
                  ),
                ],
              ),
            ),

            Icon(
              isSelected
                  ? Icons.check_circle_outline
                  : Icons.radio_button_unchecked,
              color: isSelected
                  ? const Color(0xFF2962FF)
                  : const Color(0xFFD5D9E2),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}