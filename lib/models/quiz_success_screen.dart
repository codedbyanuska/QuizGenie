import 'package:flutter/material.dart';
import 'package:quizgenie/models/question_model.dart';
import 'package:quizgenie/services/firestore_service.dart';
import 'package:quizgenie/models/quiz_display.dart';

class QuizSuccessScreen extends StatefulWidget {
  final String topic;
  const QuizSuccessScreen({super.key, required this.topic});

  @override
  State<QuizSuccessScreen> createState() => _QuizSuccessScreenState();
}

class _QuizSuccessScreenState extends State<QuizSuccessScreen> {
  late Future<List<QuestionModel>> _quizQuestions;
  List<String?> selectedAnswers = [];

  @override
  void initState() {
    super.initState();
    _quizQuestions = FirestoreService.fetchQuestion(widget.topic);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          color: const Color(0xFFE3F2FD),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Text(
                "${widget.topic} Quiz",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Answer the questions below carefully.",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF475569),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: FutureBuilder<List<QuestionModel>>(
                  future: _quizQuestions,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                          child: Text("Error: ${snapshot.error}",
                              style: const TextStyle(color: Colors.red)));
                    } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      final questions = snapshot.data!;
                      if (selectedAnswers.length != questions.length) {
                        selectedAnswers =
                            List<String?>.filled(questions.length, null);
                      }

                      return QuizDisplay(
                        questions: questions,
                        selectedAnswers: selectedAnswers,
                      );
                    } else {
                      return const Center(child: Text("No questions found."));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
