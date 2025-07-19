import 'package:flutter/material.dart';
import 'package:quizgenie/screens/all_quizzes_screen.dart';
import 'package:quizgenie/screens/teacher/tutor_home_screen.dart';

class TutorDashboard extends StatelessWidget {
  const TutorDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tutor Dashboard"),
        backgroundColor: const Color.fromARGB(255, 69, 164, 74),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.quiz),
              label: const Text("Generate Quiz"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 69, 164, 74),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                textStyle: const TextStyle(fontSize: 18),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TutorHomeScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.list),
              label: const Text("View All Quizzes"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                textStyle: const TextStyle(fontSize: 18),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AllQuizzesScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
