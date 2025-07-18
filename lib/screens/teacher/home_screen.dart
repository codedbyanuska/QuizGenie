import 'package:flutter/material.dart';
import 'tutor_screen.dart'; // Existing screen
import 'package:quizgenie/screens/all_quizzes_screen.dart'; // 👈 Create this new screen

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("This is the Home Screen!"),
            const SizedBox(height: 20),
            
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TutorScreen()),
                );
              },
              child: const Text("Go to Tutor Screen"),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AllQuizzesScreen()),
                );
              },
              child: const Text("View All Quizzes"),
            ),
          ],
        ),
      ),
    );
  }
}
