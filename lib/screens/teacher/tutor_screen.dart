import 'package:flutter/material.dart';
import 'package:quizgenie/services/together_ai_service.dart';
import 'package:quizgenie/services/firestore_service.dart';
import 'package:quizgenie/models/question_model.dart';
import 'quiz_success_screen.dart';

class TutorScreen extends StatefulWidget {
  const TutorScreen({super.key});

  @override
  State<TutorScreen> createState() => _TutorScreenState();
}

class _TutorScreenState extends State<TutorScreen> {
  final TextEditingController _topicController = TextEditingController();
  bool isLoading = false;
  List<QuestionModel> quizQuestions = [];

  Future<void> generateQuiz() async {
    final topic = _topicController.text.trim();
    if (topic.isEmpty) return;

    setState(() {
      isLoading = true;
      quizQuestions.clear();
    });

    try {
      final quizText = await TogetherAIService.generateQuiz(topic);
      _parseQuizText(quizText);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }

    setState(() => isLoading = false);
  }

  void _parseQuizText(String rawText) {
    final lines = rawText.trim().split('\n');
    QuestionModel? currentQ;
    List<QuestionModel> parsedQuestions = [];

    for (var line in lines) {
      line = line.trim();
      if (line.startsWith('Q')) {
        if (currentQ != null) parsedQuestions.add(currentQ);
        currentQ = QuestionModel(
          question: line.substring(line.indexOf('.') + 1).trim(),
          options: ['', '', '', ''],
          correctAnswer: '',
        );
      } else if (line.startsWith('A.')) {
        currentQ?.options[0] = line.substring(2).trim();
      } else if (line.startsWith('B.')) {
        currentQ?.options[1] = line.substring(2).trim();
      } else if (line.startsWith('C.')) {
        currentQ?.options[2] = line.substring(2).trim();
      } else if (line.startsWith('D.')) {
        currentQ?.options[3] = line.substring(2).trim();
      } else if (line.startsWith('Answer:')) {
        currentQ?.correctAnswer = line.split(':')[1].trim();
      }
    }
    if (currentQ != null) parsedQuestions.add(currentQ);
    setState(() => quizQuestions = parsedQuestions);
  }

  void _addEmptyQuestion() {
    setState(() {
      quizQuestions.add(
        QuestionModel(
          question: '',
          options: ['', '', '', ''],
          correctAnswer: '',
        ),
      );
    });
  }

  void _saveQuiz() async {
    if (quizQuestions.isEmpty || _topicController.text.trim().isEmpty) return;

    final topic = _topicController.text.trim();

    try {
      final mappedQuestions = quizQuestions.map((q) {
        final index = ['A', 'B', 'C', 'D'].indexOf(q.correctAnswer);
        return QuestionModel(
          question: q.question,
          options: q.options,
          correctAnswer:
              index >= 0 && index < q.options.length ? q.options[index] : '',
        );
      }).toList();

      await FirestoreService.saveQuiz(
        topic: topic,
        createdBy: 'tutor@example.com',
        questions: mappedQuestions,
      );

      // ✅ Navigate to Success Screen
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => QuizSuccessScreen(
                    topic: topic,
                  )),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving quiz: $e')),
      );
    }
  }

  Widget _buildQuestionCard(int index) {
    final q = quizQuestions[index];
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Q${index + 1}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    setState(() => quizQuestions.removeAt(index));
                  },
                ),
              ],
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Question'),
              controller: TextEditingController(text: q.question),
              onChanged: (val) => q.question = val,
            ),
            const SizedBox(height: 8),
            for (int i = 0; i < 4; i++)
              TextField(
                decoration: InputDecoration(
                    labelText: 'Option ${String.fromCharCode(65 + i)}'),
                controller: TextEditingController(text: q.options[i]),
                onChanged: (val) => q.options[i] = val,
              ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: q.correctAnswer.isEmpty ? null : q.correctAnswer,
              decoration:
                  const InputDecoration(labelText: 'Correct Answer (A/B/C/D)'),
              items: ['A', 'B', 'C', 'D'].map((opt) {
                return DropdownMenuItem(
                  value: opt,
                  child: Text(opt),
                );
              }).toList(),
              onChanged: (val) {
                setState(() => q.correctAnswer = val ?? '');
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tutor – Generate & Edit Quiz')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _topicController,
              decoration: const InputDecoration(
                labelText: 'Enter topic to generate quiz',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: isLoading ? null : generateQuiz,
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Generate Quiz'),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: quizQuestions.isEmpty
                  ? const Center(child: Text('No questions yet'))
                  : ListView.builder(
                      itemCount: quizQuestions.length,
                      itemBuilder: (_, i) => _buildQuestionCard(i),
                    ),
            ),
            const SizedBox(height: 8),
            SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _addEmptyQuestion,
                      icon: const Icon(Icons.add),
                      label: const Text('Add Question'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _saveQuiz,
                      icon: const Icon(Icons.save),
                      label: const Text('Save Quiz'),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
