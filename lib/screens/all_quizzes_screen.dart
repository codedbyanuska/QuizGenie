import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quizgenie/models/quiz_success_screen.dart';
import 'package:quizgenie/services/firestore_service.dart';

class AllQuizzesScreen extends StatelessWidget {
  const AllQuizzesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Quizzes')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: FirestoreService.fetchAllQuizzes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No quizzes available.'));
          }

          final quizzes = snapshot.data!;

          return ListView.builder(
            itemCount: quizzes.length,
            itemBuilder: (context, index) {
              final quiz = quizzes[index];
              final quizTitle = quiz['quizTitle'] ?? 'Untitled';
              final createdBy = quiz['createdBy'] ?? 'Unknown';
              final timestamp = quiz['createdAt'] as Timestamp?;
              final formattedDate = timestamp != null
                  ? DateTime.fromMillisecondsSinceEpoch(
                      timestamp.millisecondsSinceEpoch)
                      .toLocal()
                      .toString()
                      .split('.')[0]
                  : 'Unknown Date';

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                elevation: 3,
                child: ListTile(
                  title: Text(quizTitle,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('By: $createdBy\nDate: $formattedDate'),
                  isThreeLine: true,
                  trailing: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => QuizSuccessScreen(topic: quizTitle),
                        ),
                      );
                    },
                    child: const Text('Take Quiz'),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
