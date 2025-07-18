import 'package:flutter/material.dart';

class QuizSuccessScreen extends StatelessWidget {
  const QuizSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz Saved')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, size: 80, color: Colors.green),
              const SizedBox(height: 20),
              const Text(
                'Your quiz has been successfully saved!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  // You can just pop or do nothing, up to you
                },
                child: const Text('Generate New Quiz'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
