import 'package:flutter/material.dart';
import 'question_model.dart';

class QuizDisplay extends StatefulWidget {
  final List<QuestionModel> questions;
  final List<String?> selectedAnswers;
  const QuizDisplay({
    required this.questions,
    required this.selectedAnswers,
    super.key,
  });

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
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: widget.questions.length,
            itemBuilder: (context, index) {
              final q = widget.questions[index];
              return Card(
                elevation: 5,
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Q${index + 1}: ${q.question}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ...q.options.map((option) => RadioListTile<String>(
                            title: Text(option),
                            value: option,
                            groupValue: widget.selectedAnswers[index],
                            activeColor: Colors.indigo,
                            onChanged: quizSubmitted
                                ? null
                                : (val) {
                                    setState(() {
                                      widget.selectedAnswers[index] = val;
                                    });
                                  },
                          )),
                      if (quizSubmitted)
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            widget.selectedAnswers[index] ==
                                    q.correctAnswer
                                ? '✔ Correct'
                                : '✖ Wrong (Correct: ${q.correctAnswer})',
                            style: TextStyle(
                              color: widget.selectedAnswers[index] ==
                                      q.correctAnswer
                                  ? Colors.green
                                  : Colors.red,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        if (!quizSubmitted)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton(
              onPressed: () {
                if (widget.selectedAnswers.contains(null)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please answer all questions.'),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                } else {
                  submitQuiz(widget.questions);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Submit Quiz',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        if (quizSubmitted)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              'Your Score: $score / ${widget.questions.length}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E40AF),
              ),
            ),
          ),
      ],
    );
  }
}
