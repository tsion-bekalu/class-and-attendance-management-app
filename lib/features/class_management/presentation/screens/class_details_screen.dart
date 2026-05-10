import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// DOMAIN
import 'package:app/features/class_management/domain/use_cases/delete_class.dart';

// DATA
import '../../../class_management/data/class_repository_impl.dart';

// WIDGETS
import '../widgets/top_info_card.dart';
import '../widgets/menu_card.dart';

class ClassDetailsScreen extends StatefulWidget {
  final String classId;

  const ClassDetailsScreen({
    super.key,
    required this.classId,
  });

  @override
  State<ClassDetailsScreen> createState() => _ClassDetailsScreenState();
}

class _ClassDetailsScreenState extends State<ClassDetailsScreen> {
  late final ClassRepositoryImpl repository;
  late final DeleteClass deleteClassUseCase;

  Map<String, dynamic>? classData;

  @override
  void initState() {
    super.initState();
    repository = ClassRepositoryImpl();
    deleteClassUseCase = DeleteClass(repository);
    loadClass();
  }

  Future<void> loadClass() async {
    final data = await repository.getClassRawById(widget.classId);
    if (!mounted) return;
    setState(() => classData = data);
  }

  @override
  Widget build(BuildContext context) {
    if (classData == null) {
      return const Scaffold(
        body: Center(child: Text("Class not found")),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          // HEADER
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
                        color: Colors.white.withValues(alpha:0.18),
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
                          classData!["name"],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Code: ${classData!["id"]}",
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
                      child: TopInfoCard(
                        title: "Students",
                        value: classData!["students"].toString(),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: TopInfoCard(
                        title: "Status",
                        value: classData!["status"],
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
                  // SCHEDULE
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
                              "${classData!["days"].join(", ")}  ${classData!["startTime"]} - ${classData!["endTime"]}",
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

                  // PENDING BANNER
                  if (classData!["pending"] > 0)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(36),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF6EE),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFFFC58F)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline, color: Color(0xFFFF6B00)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "${classData!["pending"]} students waiting for approval",
                              style: const TextStyle(
                                color: Color(0xFFD56A1B),
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          const Icon(Icons.arrow_forward, color: Color(0xFFFF6B00)),
                        ],
                      ),
                    ),

                  const SizedBox(height: 24),

                  // MENU GRID
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 18,
                    childAspectRatio: 0.95,
                    children:  [
                      MenuCard(
                        icon: Icons.qr_code_scanner,
                        iconColor: Colors.blue,
                        iconBg: Color(0xFFDDE7FF),
                        title: 'Start Attendance',
                      ),
                      MenuCard(
                        icon: Icons.groups_2_outlined,
                        iconColor: Colors.purple,
                        iconBg: Color(0xFFF1E3FF),
                        title: 'Join Requests',
                        onTap: () {
                          context.push('/instructor/class-details/${widget.classId}/join-requests');
                        }
                      ),
                      MenuCard(
                        icon: Icons.bar_chart,
                        iconColor: Colors.green,
                        iconBg: Color(0x1F00FF00),
                        title: 'Attendance\nRecords',
                      ),
                      MenuCard(
                        icon: Icons.notifications_none,
                        iconColor: Colors.deepOrange,
                        iconBg: Color(0x1FFF9800),
                        title: 'Announcements',
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // DELETE CLASS
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
                              builder: (ctx) => AlertDialog(
                                title: const Text("Delete Class"),
                                content: const Text("Are you sure you want to delete this class?"),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx, false),
                                    child: const Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx, true),
                                    child: const Text("Delete", style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true) {
                              await deleteClassUseCase.call(widget.classId);

                              if (!context.mounted) return;

                              context.pop();
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
                                Icon(Icons.delete_outline, color: Colors.red),
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

  static BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha:0.08),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}
