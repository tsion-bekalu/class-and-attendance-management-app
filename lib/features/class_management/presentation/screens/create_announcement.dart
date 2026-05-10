import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';

class CreateAnnouncementScreen extends StatefulWidget {
  const CreateAnnouncementScreen({super.key});

  @override
  State<CreateAnnouncementScreen> createState() => _CreateAnnouncementScreen();
}

class _CreateAnnouncementScreen extends State<CreateAnnouncementScreen> {
  final _titleController = TextEditingController();
  final _messageController = TextEditingController();
  int _titleLength = 0;
  int _messageLength = 0;

  @override
  void initState() {
    super.initState();
    _titleController.addListener(() {
      setState(() => _titleLength = _titleController.text.length);
    });
    _messageController.addListener(() {
      setState(() => _messageLength = _messageController.text.length);
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // Title Input section
                _buildInputSection(
                  label: "Title",
                  hint: "e.g., Class Cancelled Tomorrow",
                  controller: _titleController,
                  maxLength: 100,
                  currentLength: _titleLength,
                  prefixIcon: Icons.notifications_none_outlined,
                ),
                const SizedBox(height: 20),

                // Message Input section
                _buildInputSection(
                  label: "Message",
                  hint: "Write your announcement message here...",
                  controller: _messageController,
                  maxLength: 500,
                  currentLength: _messageLength,
                  maxLines: 8,
                ),
                const SizedBox(height: 24),

                // Blue Info Box
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDF2FE),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFCAD9FB)),
                  ),
                  child: const Text(
                    "All students enrolled in this class will be able to see this announcement.",
                    style: TextStyle(color: Color(0xFF1E3A8A), height: 1.4),
                  ),
                ),
                const SizedBox(height: 32),

                // Action Buttons (Row)
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => context.pop(),
                        style: TextButton.styleFrom(
                          backgroundColor: const Color(0xFFF0F0F0),
                          foregroundColor: const Color(0xFF505050),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text("Cancel"),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: Handle post logic
                          context.pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text("Post Announcement"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Header matching New Announcement view
  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 30),
      width: double.infinity,
      decoration: const BoxDecoration(color: AppTheme.primaryColor),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
              onPressed: () => context.pop(),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "New Announcement",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                "Computer Science",
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper widget for input sections
  Widget _buildInputSection({
    required String label,
    required String hint,
    required TextEditingController controller,
    required int maxLength,
    required int currentLength,
    int maxLines = 1,
    IconData? prefixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF6B7280),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.black26),
            prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: Colors.black26) : null,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.all(16),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.primaryColor),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            "$currentLength/$maxLength characters",
            style: const TextStyle(fontSize: 12, color: Colors.black38),
          ),
        ),
      ],
    );
  }
}