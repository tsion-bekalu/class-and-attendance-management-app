import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:class-and-attendance-management-app/core/theme/app_theme.dart';
import 'package:class-and-attendance-management-app/features/auth/domain/models/auth_role.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 80),
          Image.asset('assets/logo1.png', height: 80),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Join as', style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 20),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: mockRoles.length,
                  itemBuilder: (context, index) {
                    final role = mockRoles[index];
                    return Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: Icon(role.icon, color: AppTheme.primaryColor),
                        title: Text(role.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(role.description),
                        onTap: () => context.push('/login-form', extra: role.name),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}