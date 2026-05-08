import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../class_management/data/class_local_storage.dart';

class ClassDetailsScreen extends StatelessWidget {
  final String classId;

  const ClassDetailsScreen({
    super.key,
    required this.classId,
  });

  @override
  Widget build(BuildContext context) {
    final classData = ClassLocalStorage.getClassById(classId);

    if (classData == null) {
      return const Scaffold(
        body: Center(
          child: Text("Class not found"),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          // 🔵 HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 55,
              left: 20,
              right: 20,
              bottom: 28,
            ),
            decoration: const BoxDecoration(
              color: Color(0xFF1E5BFF),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      height: 42,
                      width: 42,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () => context.pop(),
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),

                    const SizedBox(width: 14),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          classData["name"],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          "Code: ${classData["id"]}",
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: _topInfoCard(
                        title: "Students",
                        value: classData["students"].toString(),
                      ),
                    ),

                    const SizedBox(width: 14),

                    Expanded(
                      child: _topInfoCard(
                        title: "Status",
                        value: classData["status"],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // BODY
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  // 📅 SCHEDULE
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: _cardDecoration(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Schedule",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF303443),
                          ),
                        ),

                        const SizedBox(height: 16),

                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today_outlined,
                              color: Color(0xFF2D6BFF),
                              size: 18,
                            ),

                            const SizedBox(width: 12),

                            Text(
                              "${classData["days"].join(", ")}  ${classData["startTime"]} - ${classData["endTime"]}",
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ⚠️ PENDING BANNER
                  if (classData["pending"] > 0)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(36),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF6EE),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFFFFC58F),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Color(0xFFFF6B00),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: Text(
                              "${classData["pending"]} students waiting for approval",
                              style: const TextStyle(
                                color: Color(0xFFD56A1B),
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                          ),

                          const Icon(
                            Icons.arrow_forward,
                            color: Color(0xFFFF6B00),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 24),

                  // 🔲 MENU GRID (ORDER FIXED)
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 18,
                    childAspectRatio: 0.95,
                    children: [
                      // 1️⃣ START ATTENDANCE
                      _menuCard(
                        icon: Icons.qr_code_scanner,
                        iconColor: Colors.blue,
                        iconBg: const Color(0xFFDDE7FF),
                        title: 'Start Attendance',
                      ),

                      // 2️⃣ JOIN REQUESTS (with badge)
                      SizedBox.expand(
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: _menuCard(
                                icon: Icons.groups_2_outlined,
                                iconColor: Colors.purple,
                                iconBg: const Color(0xFFF1E3FF),
                                title: 'Join Requests',
                              ),
                            ),

                            if (classData["pending"] > 0)
                              Positioned(
                                top: 10,
                                right: 10,
                                child: Container(
                                  height: 24,
                                  width: 24,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFFF6B00),
                                    shape: BoxShape.circle,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    classData["pending"].toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),

                      // 3️⃣ ATTENDANCE RECORDS
                      _menuCard(
                        icon: Icons.bar_chart,
                        iconColor: Colors.green,
                        iconBg: Colors.green.withValues(alpha: 0.12),
                        title: 'Attendance\nRecords',
                      ),

                      // 4️⃣ ANNOUNCEMENTS
                      _menuCard(
                        icon: Icons.notifications_none,
                        iconColor: Colors.deepOrange,
                        iconBg: Colors.orange.withValues(alpha: 0.12),
                        title: 'Announcements',
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // ❌ DELETE CLASS (WORKING)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: _cardDecoration(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Class Management",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF303443),
                          ),
                        ),

                        const SizedBox(height: 20),

                        GestureDetector(
                          onTap: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (ctx) {
                                return AlertDialog(
                                  title: const Text("Delete Class"),
                                  content: const Text(
                                      "Are you sure you want to delete this class?"),
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
                              ClassLocalStorage.deleteClass(classId);

                              if (!context.mounted) return;

                              context.pop(); // go back after delete
                            }
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFEFEF),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                ),

                                SizedBox(width: 8),

                                Text(
                                  "Delete Class",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
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
        ],
      ),
    );
  }

  // 🔵 TOP INFO CARD
  static Widget _topInfoCard({
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // 🔲 MENU CARD
  static Widget _menuCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
  }) {
    return Container(
      decoration: _cardDecoration(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: iconBg,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 26,
            ),
          ),

          const SizedBox(height: 16),

          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Color(0xFF303443),
            ),
          ),
        ],
      ),
    );
  }

  // 🎨 CARD STYLE
  static BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}
