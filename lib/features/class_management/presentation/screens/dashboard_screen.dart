import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// WIDGETS
import '../widgets/stat_card.dart';
import '../widgets/class_card.dart';
import '../widgets/quick_action_card.dart';

// DOMAIN
import 'package:app/features/class_management/domain/use_cases/get_classes.dart';
import 'package:app/features/class_management/domain/entities/class_entity.dart';

// DATA
import '../../../class_management/data/class_repository_impl.dart';

class InstructorDashboardScreen extends StatefulWidget {
  const InstructorDashboardScreen({super.key});

  @override
  State<InstructorDashboardScreen> createState() =>
      _InstructorDashboardScreenState();
}

class _InstructorDashboardScreenState extends State<InstructorDashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late final ClassRepositoryImpl repository;
  late final GetClasses getClassesUseCase;

  List<ClassEntity> classes = [];

  @override
  void initState() {
    super.initState();
    repository = ClassRepositoryImpl();
    getClassesUseCase = GetClasses(repository);
    loadClasses();
  }

  Future<void> loadClasses() async {
    final result = await getClassesUseCase.call();
    if (!mounted) return;
    setState(() => classes = result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: buildDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildHeader(),
            buildBody(),
          ],
        ),
      ),
    );
  }

  // ---------------- HEADER ----------------

  Widget buildHeader() {
    return Container(
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
                    "Mr.Tilahun",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => _scaffoldKey.currentState?.openEndDrawer(),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Colors.white24,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.menu, color: Colors.white),
                ),
              ),
            ],
          ),

          const SizedBox(height: 30),

          Row(
            children: [
              Expanded(
                child: StatCard(
                  icon: Icons.menu_book_outlined,
                  title: "Total Classes",
                  value: classes.length.toString(),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: StatCard(
                  icon: Icons.groups_2_outlined,
                  title: "Students",
                  value: classes.fold<int>(
                    0,
                    (sum, c) => sum + c.students,
                  ).toString(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------- BODY ----------------

  Widget buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildQuickActions(),
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
          buildClassList(),
        ],
      ),
    );
  }

  // ---------------- DRAWER ----------------

  Widget buildDrawer() {
    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 40),
              ListTile(
                leading: const Icon(Icons.calendar_today_outlined),
                title: const Text("Timetable"),
                onTap: () {
                  Navigator.pop(context);
                  context.push('/student/timetable');
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text("Logout", style: TextStyle(color: Colors.red)),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: const Text("Delete Account",
                    style: TextStyle(color: Colors.red)),
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- QUICK ACTIONS ----------------

  Widget buildQuickActions() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.08),
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
                child: QuickActionCard(
                  color: const Color(0xFFEAF1FF),
                  iconColor: const Color(0xFF1E5EFF),
                  icon: Icons.add,
                  title: "New Class",
                  onTap: () async {
                    await context.push('/instructor/create-class');
                    loadClasses();
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: QuickActionCard(
                  color: const Color(0xFFF5ECFF),
                  iconColor: const Color(0xFF9C27FF),
                  icon: Icons.calendar_month_outlined,
                  title: "Timetable",
                  onTap: () => context.push('/student/timetable'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------- CLASS LIST ----------------

  Widget buildClassList() {
    if (classes.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 20),
        child: Text("No classes created yet",
            style: TextStyle(color: Colors.grey)),
      );
    }

    return Column(
      children: classes.map((c) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 18),
          child: ClassCard(
            name: c.name,
            code: c.id,
            time: "${c.days.join(", ")} - ${c.startTime} to ${c.endTime}",
            students: c.students.toString(),
            pending: c.pending,
            onTap: () async {
              await context.push('/instructor/class-details/${c.id}');
              loadClasses();
            },
          ),
        );
      }).toList(),
    );
  }
}
