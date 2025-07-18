import 'package:flutter/material.dart';
import 'tutor_screen.dart'; // Make sure this path is correct

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
          ],
        ),
      ),
    );
  }
}
