import 'package:flutter/material.dart';
import 'package:app/core/models/class_model.dart'; 

class ClassCard extends StatelessWidget {
  final Class classData; 
  final VoidCallback onTap;

  const ClassCard({
    super.key,
    required this.classData,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          classData.name, 
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text("Instructor: ${classData.instructorId}"),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.access_time, size: 16, color: Colors.grey),
                const SizedBox(width: 1),
                Text(classData.scheduleString(context)), 
              ],
            ),
          ],
        ),
      ),
    );
  }
}