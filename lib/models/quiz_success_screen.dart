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
    return Scaffold(
      appBar: AppBar(title: Text('${widget.topic} Quiz')),
      body: FutureBuilder<List<QuestionModel>>(
        future: _quizQuestions,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final questions = snapshot.data!;
            if (selectedAnswers.length != questions.length) {
              selectedAnswers = List<String?>.filled(questions.length, null);
            }

            return QuizDisplay(
                questions: questions, selectedAnswers: selectedAnswers);
          } else {
            return Center(child: Text("No data available"));
          }
        },
      ),
    );
  }
}
