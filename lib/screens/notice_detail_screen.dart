import 'package:flutter/material.dart';

class NoticeDetailScreen extends StatelessWidget {
  final String title;
  final String description;
  final String date;
  final String category;

  const NoticeDetailScreen({
    super.key,
    required this.title,
    required this.description,
    required this.date,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notice Details'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Chip(
              label: Text(category),
              backgroundColor: Colors.indigo.shade100,
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                const Icon(Icons.calendar_month, color: Colors.indigo),
                const SizedBox(width: 8),
                Text(date),
              ],
            ),
            const Divider(height: 35),
            const Text(
              'Announcement',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: const TextStyle(fontSize: 16, height: 1.6),
            ),
          ],
        ),
      ),
    );
  }
}
