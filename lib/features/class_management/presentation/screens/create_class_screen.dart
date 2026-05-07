import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../class_management/data/class_local_storage.dart';

class CreateClassScreen extends StatefulWidget {
  const CreateClassScreen({super.key});

  @override
  State<CreateClassScreen> createState() => _CreateClassScreenState();
}

class _CreateClassScreenState extends State<CreateClassScreen> {
  final TextEditingController classNameController = TextEditingController();
  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();

  final List<String> days = ["Mon", "Tue", "Wed", "Thu", "Fri"];
  List<String> selectedDays = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // HEADER
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                decoration: const BoxDecoration(color: Color(0xFF1E5EFF)),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.18),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Text(
                      "Create Class",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // CLASS NAME
                    buildCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Class Name",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF2C3444))),
                          const SizedBox(height: 14),
                          TextField(
                            controller: classNameController,
                            decoration: inputDecoration(
                              hint: "e.g., Computer Science",
                              icon: Icons.menu_book_outlined,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // DAYS
                    buildCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Select Days",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF2C3444))),
                          const SizedBox(height: 18),
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: days.map((day) {
                              final isSelected = selectedDays.contains(day);
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isSelected
                                        ? selectedDays.remove(day)
                                        : selectedDays.add(day);
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 22, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? const Color(0xFF1E5EFF)
                                        : const Color(0xFFF1F2F6),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Text(
                                    day,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: isSelected
                                          ? Colors.white
                                          : const Color(0xFF374151),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // TIME
                    buildCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Class Time",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF2C3444))),
                          const SizedBox(height: 18),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Start Time",
                                        style:
                                            TextStyle(color: Color(0xFF6D7485))),
                                    const SizedBox(height: 8),
                                    TextField(
                                      controller: startTimeController,
                                      decoration: inputDecoration(
                                        icon: Icons.access_time_outlined,
                                        hint: "11:30",
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("End Time",
                                        style:
                                            TextStyle(color: Color(0xFF6D7485))),
                                    const SizedBox(height: 8),
                                    TextField(
                                      controller: endTimeController,
                                      decoration: inputDecoration(
                                        icon: Icons.access_time_outlined,
                                        hint: "12:30",
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ⭐ INFO BOX (exactly before button)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE7F0FF),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.info_outline, color: Color(0xFF1E5EFF)),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "A unique join code will be generated automatically when you create the class. Share it with students to let them join.",
                              style: TextStyle(
                                fontSize: 15,
                                color: Color(0xFF1E293B),
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // CREATE BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: 58,
                      child: ElevatedButton(
                        onPressed: () {
                          if (classNameController.text.isEmpty ||
                              selectedDays.isEmpty ||
                              startTimeController.text.isEmpty ||
                              endTimeController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Please fill all fields"),
                              ),
                            );
                            return;
                          }

                          final id =
                              "${classNameController.text.replaceAll(" ", "").substring(0, 3).toUpperCase()}${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}";

                          ClassLocalStorage.addClass({
                            "id": id,
                            "name": classNameController.text,
                            "students": 45,
                            "status": "Active",
                            "days": selectedDays,
                            "startTime": startTimeController.text,
                            "endTime": endTimeController.text,
                            "pending": 3,
                          });

                          context.go('/instructor/class-details/$id');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E5EFF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          "Create Class",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
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

  InputDecoration inputDecoration({required IconData icon, String? hint}) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: const Color(0xFF9AA3B2)),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 18),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFD9DDE5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFF1E5EFF)),
      ),
    );
  }

  Widget buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }
}
