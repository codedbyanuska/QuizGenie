import 'package:flutter/material.dart';
import 'question_model.dart';

class QuizDisplay extends StatefulWidget {
  final List<QuestionModel> questions;
  final List<String?> selectedAnswers;
  const QuizDisplay(
      {required this.questions, required this.selectedAnswers, super.key});

  @override
  State<QuizDisplay> createState() => _QuizDisplayState();
}

class _QuizDisplayState extends State<QuizDisplay> {
  bool quizSubmitted = false;

  int score = 0;

  void submitQuiz(List<QuestionModel> questions) {
    int correctCount = 0;
    for (int i = 0; i < questions.length; i++) {
      if (widget.selectedAnswers[i] == questions[i].correctAnswer) {
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
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.questions.length,
              itemBuilder: (context, index) {
                final q = widget.questions[index];
                return Card(
                  margin: EdgeInsets.all(8),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Q${index + 1}: ${q.question}',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        ...q.options.map((option) => RadioListTile<String>(
                              title: Text(option),
                              value: option,
                              groupValue: widget.selectedAnswers[index],
                              onChanged: quizSubmitted
                                  ? null
                                  : (val) {
                                      setState(() {
                                        widget.selectedAnswers[index] = val;
                                      });
                                    },
                            )),
                        if (quizSubmitted)
                          Text(
                            widget.selectedAnswers[index] == q.correctAnswer
                                ? ' Correct'
                                : ' Wrong (Answer: ${q.correctAnswer})',
                            style: TextStyle(
                                color: widget.selectedAnswers[index] ==
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
                if (widget.selectedAnswers.contains(null)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please answer all questions')),
                  );
                } else {
                  submitQuiz(widget.questions);
                }
              },
              child: Text('Submit'),
            ),
          if (quizSubmitted)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Your Score: $score/${widget.questions.length}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    );
  }
}
