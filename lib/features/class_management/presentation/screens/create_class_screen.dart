import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// DOMAIN
import 'package:app/features/class_management/domain/entities/class_entity.dart';
import 'package:app/features/class_management/domain/use_cases/create_class.dart';

// DATA
import 'package:app/features/class_management/data/class_repository_impl.dart';

// WIDGETS
import '../widgets/form_card.dart';
import '../widgets/day_chip.dart';
import '../widgets/time_input.dart';
import '../widgets/info_box.dart';

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

  late final ClassRepositoryImpl repository;
  late final CreateClass createClassUseCase;

  @override
  void initState() {
    super.initState();
    repository = ClassRepositoryImpl();
    createClassUseCase = CreateClass(repository);
  }

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
                          color: Colors.white.withValues(alpha:0.18),
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
                    FormCard(
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
                            decoration: const InputDecoration(
                              hintText: "e.g., Computer Science",
                              prefixIcon: Icon(Icons.menu_book_outlined,
                                  color: Color(0xFF9AA3B2)),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 18),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(16)),
                                borderSide:
                                    BorderSide(color: Color(0xFFD9DDE5)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(16)),
                                borderSide:
                                    BorderSide(color: Color(0xFF1E5EFF)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // DAYS
                    FormCard(
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
                              return DayChip(
                                day: day,
                                selected: selectedDays.contains(day),
                                onTap: () {
                                  setState(() {
                                    selectedDays.contains(day)
                                        ? selectedDays.remove(day)
                                        : selectedDays.add(day);
                                  });
                                },
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // TIME
                    FormCard(
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
                                child: TimeInput(
                                  label: "Start Time",
                                  controller: startTimeController,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: TimeInput(
                                  label: "End Time",
                                  controller: endTimeController,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // INFO BOX
                    const InfoBox(
                      text:
                          "A unique join code will be generated automatically when you create the class. Share it with students to let them join.",
                    ),

                    const SizedBox(height: 24),

                    // CREATE BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: 58,
                      child: ElevatedButton(
                        onPressed: () async {
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

                          final newClass = ClassEntity(
                            id: id,
                            name: classNameController.text,
                            description: "Instructor class",
                            days: selectedDays,
                            startTime: startTimeController.text,
                            endTime: endTimeController.text,
                            students: 0,
                            pending: 0,
                            status: "Active",
 
                          );

                          await createClassUseCase.call(newClass);

                          if (!context.mounted) return;
                          context.push('/instructor/class-details/$id');
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
}
