import 'package:flutter/material.dart';
import 'package:quizgenie/models/question_model.dart';
import 'package:quizgenie/services/firestore_service.dart';

class QuizSuccessScreen extends StatefulWidget {
  final String topic;
  const QuizSuccessScreen({Key? key, required this.topic}) : super(key: key);

  @override
  State<QuizSuccessScreen> createState() => _QuizSuccessScreenState();
}

class _QuizSuccessScreenState extends State<QuizSuccessScreen> {
  late Future<List<QuestionModel>> _quizQuestions;
  List<String?> selectedAnswers = [];
  bool quizSubmitted = false;
  int score = 0;

  @override
  void initState() {
    super.initState();
    _quizQuestions = FirestoreService.fetchQuestion(widget.topic);
  }

  void submitQuiz(List<QuestionModel> questions) {
    int correctCount = 0;
    for (int i = 0; i < questions.length; i++) {
      if (selectedAnswers[i] == questions[i].correctAnswer) {
        correctCount++;
      }
    }

    setState(() {
      quizSubmitted = true;
      score = correctCount;
    });
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

            return SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: questions.length,
                      itemBuilder: (context, index) {
                        final q = questions[index];
                        return Card(
                          margin: EdgeInsets.all(8),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Q${index + 1}: ${q.question}',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                ...q.options
                                    .map((option) => RadioListTile<String>(
                                          title: Text(option),
                                          value: option,
                                          groupValue: selectedAnswers[index],
                                          onChanged: quizSubmitted
                                              ? null
                                              : (val) {
                                                  setState(() {
                                                    selectedAnswers[index] =
                                                        val;
                                                  });
                                                },
                                        )),
                                if (quizSubmitted)
                                  Text(
                                    selectedAnswers[index] == q.correctAnswer
                                        ? ' Correct'
                                        : ' Wrong (Answer: ${q.correctAnswer})',
                                    style: TextStyle(
                                        color: selectedAnswers[index] ==
                                                q.correctAnswer
                                            ? Colors.green
                                            : Colors.red),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  if (!quizSubmitted)
                    ElevatedButton(
                      onPressed: () {
                        if (selectedAnswers.contains(null)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Please answer all questions')),
                          );
                        } else {
                          submitQuiz(questions);
                        }
                      },
                      child: Text('Submit'),
                    ),
                  if (quizSubmitted)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Your Score: $score/${questions.length}',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ),
            );
          } else {
            return Center(child: Text("No data available"));
          }
        },
      ),
    );
  }
}
