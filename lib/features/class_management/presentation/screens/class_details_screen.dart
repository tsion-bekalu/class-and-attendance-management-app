import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../class_management/data/class_local_storage.dart';

class ClassDetailsScreen extends StatelessWidget {
  final String classId;

  const ClassDetailsScreen({super.key, required this.classId});

  @override
  Widget build(BuildContext context) {
    final classData = ClassLocalStorage.getClassById(classId);

    if (classData == null) {
      return const Scaffold(
        body: Center(child: Text("Class not found")),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ⭐ HEADER (exact inspo)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(22, 24, 22, 40),
                decoration: const BoxDecoration(
                  color: Color(0xFF1E5EFF),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(35),
                    bottomRight: Radius.circular(35),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => context.pop(),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: .18),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.arrow_back,
                                color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                classData['name'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Code: ${classData['id']}",
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 26),

                    Row(
                      children: [
                        Expanded(
                          child: statCard(
                            title: "Students",
                            value: classData['students'].toString(),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: statCard(
                            title: "Status",
                            value: classData['status'],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // ⭐ BODY CONTENT
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // ⭐ SCHEDULE CARD
                    buildCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Schedule",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_today_outlined,
                                color: Color(0xFF1E5EFF),
                                size: 22,
                              ),
                              const SizedBox(width: 14),
                              Text(
                                "${classData['days'].join(', ')}   ${classData['startTime']} - ${classData['endTime']}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF5B6475),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ⭐ PENDING APPROVAL BOX
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF7F0),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: const Color(0xFFFFB16A),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Color(0xFFFF5C00),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "${classData['pending']} students waiting for approval",
                              style: const TextStyle(
                                color: Color(0xFFE85B00),
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward,
                            color: Color(0xFFFF5C00),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ⭐ ACTION GRID (exact inspo)
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 1,
                      children: [
                        actionCard(
                          icon: Icons.qr_code_scanner,
                          iconBg: const Color(0xFFE7F0FF),
                          iconColor: const Color(0xFF1E5EFF),
                          title: "Start Attendance",
                          onTap: () {},
                        ),
                        actionCard(
                          icon: Icons.people_outline,
                          iconBg: const Color(0xFFF2E9FF),
                          iconColor: const Color(0xFF9B27FF),
                          title: "Join Requests",
                          badge: classData['pending'].toString(),
                          onTap: () {},
                        ),
                        actionCard(
                          icon: Icons.bar_chart,
                          iconBg: const Color(0xFFE7F9EE),
                          iconColor: const Color(0xFF22B45B),
                          title: "Attendance\nRecords",
                          onTap: () {},
                        ),
                        actionCard(
                          icon: Icons.notifications_none,
                          iconBg: const Color(0xFFFFF1E3),
                          iconColor: const Color(0xFFFF7A00),
                          title: "Announcements",
                          onTap: () {},
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // ⭐ DELETE CLASS SECTION
                    buildCard(
                      child: GestureDetector(
                        onTap: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (ctx) {
                              return AlertDialog(
                                title: const Text("Delete Class"),
                                content: const Text(
                                  "Are you sure you want to delete this class?",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(ctx).pop(false),
                                    child: const Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(ctx).pop(true),
                                    child: const Text(
                                      "Delete",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );

                          if (confirm == true) {
                            if (!context.mounted) return;
                            ClassLocalStorage.deleteClass(classId);
                            context.pop();
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF0F0),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.delete_outline, color: Colors.red),
                              SizedBox(width: 8),
                              Text(
                                "Delete Class",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ⭐ SMALL COMPONENTS (exact inspo styling)

  Widget statCard({required String title, required String value}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .16),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(color: Colors.white70, fontSize: 15)),
          const SizedBox(height: 8),
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .08),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget actionCard({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required VoidCallback onTap,
    String? badge,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(34),
                  decoration: BoxDecoration(
                    color: iconBg,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: iconColor, size: 28),
                ),
                const SizedBox(height: 18),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ],
            ),
          ),

          if (badge != null)
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Color(0xFFFF6A00),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  badge,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
