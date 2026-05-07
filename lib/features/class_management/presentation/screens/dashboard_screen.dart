import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class InstructorDashboardScreen extends StatelessWidget {
  const InstructorDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // TOP BLUE HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                top: 60,
                left: 22,
                right: 22,
                bottom: 60,
              ),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Welcome back,",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            "Mr. Tilahun",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: Colors.white24,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.menu, color: Colors.white),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  Row(
                    children: [
                      Expanded(
                        child: statCard(
                          icon: Icons.menu_book_outlined,
                          title: "Total Classes",
                          value: "2",
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: statCard(
                          icon: Icons.groups_2_outlined,
                          title: "Students",
                          value: "77",
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // QUICK ACTIONS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Quick Actions",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1D2433),
                          ),
                        ),

                        const SizedBox(height: 20),

                        Row(
                          children: [
                            Expanded(
                              child: quickActionCard(
                                color: const Color(0xFFEAF1FF),
                                iconColor: const Color(0xFF1E5EFF),
                                icon: Icons.add,
                                title: "New Class",
                                onTap: () => context.go('/instructor/create-class'),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: quickActionCard(
                                color: const Color(0xFFF5ECFF),
                                iconColor: const Color(0xFF9C27FF),
                                icon: Icons.calendar_month_outlined,
                                title: "Timetable",
                                onTap: () => context.go('/student/timetable'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),



                  const SizedBox(height: 24),

                  const Text(
                    "My Classes",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1D2433),
                    ),
                  ),

                  const SizedBox(height: 18),

                  classCard(
                    title: "Computer Science 101",
                    code: "CS101XYZ",
                    time: "Mon, Wed, Fri - 9:00 AM",
                    students: "45",
                    showPending: true,
                    onTap: () => context.go('/instructor/classes'),
                  ),

                  const SizedBox(height: 18),

                  classCard(
                    title: "Data Structures",
                    code: "DS201ABC",
                    time: "Tue, Thu - 2:00 PM",
                    students: "32",
                    showPending: false,
                    onTap: () => context.go('/instructor/classes'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------ COMPONENTS ------------------

  Widget statCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Colors.white24,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(color: Colors.white70, fontSize: 15)),
              const SizedBox(height: 5),
              Text(value,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }

  Widget quickActionCard({
    required Color color,
    required Color iconColor,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 22),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: iconColor, shape: BoxShape.circle),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF2A3142),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget classCard({
    required String title,
    required String code,
    required String time,
    required String students,
    required bool showPending,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1D2433),
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD8F7E4),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "active",
                    style: TextStyle(
                      color: Color(0xFF20A15A),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Text(
              "Code: $code",
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF7B8495),
              ),
            ),

            const SizedBox(height: 14),

            Row(
              children: [
                const Icon(Icons.access_time_outlined,
                    size: 18, color: Color(0xFF687082)),
                const SizedBox(width: 8),
                Text(time,
                    style: const TextStyle(
                        fontSize: 15, color: Color(0xFF5E6678))),
                const SizedBox(width: 10),
                const Icon(Icons.people_outline,
                    size: 18, color: Color(0xFF687082)),
                const SizedBox(width: 4),
                Text(students,
                    style: const TextStyle(
                        fontSize: 15, color: Color(0xFF5E6678))),
              ],
            ),

            if (showPending) ...[
              const SizedBox(height: 18),
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF2E8),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.error_outline,
                        color: Color(0xFFFF6A00), size: 18),
                    SizedBox(width: 10),
                    Text(
                      "3 pending join requests",
                      style: TextStyle(
                        color: Color(0xFFFF5C00),
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
