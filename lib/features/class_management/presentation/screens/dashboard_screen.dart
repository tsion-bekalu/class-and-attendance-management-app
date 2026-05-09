import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:app/features/class_management/data/class_local_storage.dart';

class InstructorDashboardScreen extends StatefulWidget {
  const InstructorDashboardScreen({super.key});

  @override
  State<InstructorDashboardScreen> createState() =>
      _InstructorDashboardScreenState();
}

class _InstructorDashboardScreenState
    extends State<InstructorDashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final classes = ClassLocalStorage.getAllClasses();

    return Scaffold(
      key: _scaffoldKey,

      // ✅ SIDEBAR DRAWER
      endDrawer: Drawer(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(0),
            bottomRight: Radius.circular(0),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),

                // 👤 PROFILE
                Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: const BoxDecoration(
                        color: Color(0xFF1E5EFF),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          "H",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 14),

                    const Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Mr.Tilahun",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        SizedBox(height: 4),

                        Text(
                          "Instructor",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // 📅 TIMETABLE
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(
                    Icons.calendar_today_outlined,
                    color: Color(0xFF4B5563),
                  ),
                  title: const Text(
                    "Timetable",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/student/timetable');
                  },
                ),

                const SizedBox(height: 6),

                // 🚪 LOGOUT
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(
                    Icons.logout,
                    color: Colors.red,
                  ),
                  title: const Text(
                    "Logout",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);

                    // logout logic
                  },
                ),

                const SizedBox(height: 6),

                // 🗑 DELETE ACCOUNT
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                  ),
                  title: const Text(
                    "Delete Account",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            // 🔵 HEADER
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
                  // TOP ROW
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
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
                            "Mr.Tilahun",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),

                      // 🍔 MENU BUTTON
                      GestureDetector(
                        onTap: () {
                          _scaffoldKey.currentState
                              ?.openEndDrawer();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(
                            color: Colors.white24,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.menu,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // 📊 STATS
                  Row(
                    children: [
                      Expanded(
                        child: statCard(
                          icon:
                              Icons.menu_book_outlined,
                          title: "Total Classes",
                          value: classes.length
                              .toString(),
                        ),
                      ),

                      const SizedBox(width: 16),

                      Expanded(
                        child: statCard(
                          icon:
                              Icons.groups_2_outlined,
                          title: "Students",
                          value: classes
                              .fold<int>(
                                0,
                                (sum, c) =>
                                    sum +
                                    (c["students"]
                                        as int),
                              )
                              .toString(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // BODY
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 20,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  // ⚡ QUICK ACTIONS
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withValues(alpha: 0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Quick Actions",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight:
                                FontWeight.w600,
                            color:
                                Color(0xFF1D2433),
                          ),
                        ),

                        const SizedBox(height: 20),

                        Row(
                          children: [
                            Expanded(
                              child:
                                  quickActionCard(
                                color:
                                    const Color(
                                        0xFFEAF1FF),
                                iconColor:
                                    const Color(
                                        0xFF1E5EFF),
                                icon: Icons.add,
                                title:
                                    "New Class",
                                onTap: () async {
                                  await context.push(
                                    '/instructor/create-class',
                                  );

                                  setState(() {});
                                },
                              ),
                            ),

                            const SizedBox(
                                width: 16),

                            Expanded(
                              child:
                                  quickActionCard(
                                color:
                                    const Color(
                                        0xFFF5ECFF),
                                iconColor:
                                    const Color(
                                        0xFF9C27FF),
                                icon: Icons
                                    .calendar_month_outlined,
                                title:
                                    "Timetable",
                                onTap: () {
                                  context.push(
                                    '/student/timetable',
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 📘 MY CLASSES
                  const Text(
                    "My Classes",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight:
                          FontWeight.w700,
                      color: Color(0xFF1D2433),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // CLASS LIST
                  if (classes.isEmpty)
                    const Padding(
                      padding:
                          EdgeInsets.only(top: 20),
                      child: Text(
                        "No classes created yet",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    )
                  else
                    Column(
                      children: classes.map((c) {
                        return Padding(
                          padding:
                              const EdgeInsets.only(
                            bottom: 18,
                          ),
                          child: classCard(
                            title: c["name"],
                            code: c["id"],
                            time:
                                "${c["days"].join(", ")} - ${c["startTime"]} to ${c["endTime"]}",
                            students: c["students"]
                                .toString(),
                            showPending:
                                c["pending"] > 0,
                            onTap: () async {
                              await context.push(
                                '/instructor/class-details/${c["id"]}',
                              );

                              setState(() {});
                            },
                          ),
                        );
                      }).toList(),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔵 STAT CARD
  Widget statCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 18,
      ),
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
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),

          const SizedBox(width: 12),

          Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ⚡ QUICK ACTION CARD
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
        padding:
            const EdgeInsets.symmetric(vertical: 22),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: iconColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 28,
              ),
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

  // 📘 CLASS CARD
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
              color:
                  Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            // TITLE + STATUS
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight:
                          FontWeight.w600,
                      color: Color(0xFF1D2433),
                    ),
                  ),
                ),

                Container(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color:
                        const Color(0xFFD8F7E4),
                    borderRadius:
                        BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "active",
                    style: TextStyle(
                      color: Color(0xFF20A15A),
                      fontWeight:
                          FontWeight.w500,
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
                const Icon(
                  Icons.access_time_outlined,
                  size: 18,
                  color: Color(0xFF687082),
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: Text(
                    time,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Color(0xFF5E6678),
                    ),
                  ),
                ),

                const Icon(
                  Icons.people_outline,
                  size: 18,
                  color: Color(0xFF687082),
                ),

                const SizedBox(width: 4),

                Text(
                  students,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF5E6678),
                  ),
                ),
              ],
            ),

            if (showPending) ...[
              const SizedBox(height: 18),

              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF2E8),
                  borderRadius:
                      BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Color(0xFFFF6A00),
                      size: 18,
                    ),

                    const SizedBox(width: 10),

                    Text(
                      "$students pending join requests",
                      style: const TextStyle(
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