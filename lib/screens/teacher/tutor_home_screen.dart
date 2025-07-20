import 'package:flutter/material.dart';
import 'package:quizgenie/services/together_ai_service.dart';
import 'package:quizgenie/services/firestore_service.dart';
import 'package:quizgenie/models/question_model.dart';
import 'package:quizgenie/models/quiz_success_screen.dart';

class TutorHomeScreen extends StatefulWidget {
  const TutorHomeScreen({super.key});

  @override
  State<TutorHomeScreen> createState() => _TutorHomeScreenState();
}

class _TutorHomeScreenState extends State<TutorHomeScreen> {
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
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Q${index + 1}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => setState(() => quizQuestions.removeAt(index)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: TextEditingController(text: q.question),
              onChanged: (val) => q.question = val,
              decoration: const InputDecoration(labelText: 'Question'),
              maxLines: null,
              keyboardType: TextInputType.multiline,
            ),
            const SizedBox(height: 8),
            for (int i = 0; i < 4; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TextField(
                  controller: TextEditingController(text: q.options[i]),
                  onChanged: (val) => q.options[i] = val,
                  decoration: InputDecoration(
                    labelText: 'Option ${String.fromCharCode(65 + i)}',
                  ),
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                ),
              ),
            DropdownButtonFormField<String>(
              value: q.correctAnswer.isEmpty ? null : q.correctAnswer,
              decoration: const InputDecoration(
                  labelText: 'Correct Answer (A/B/C/D)'),
              items: ['A', 'B', 'C', 'D']
                  .map((opt) => DropdownMenuItem(value: opt, child: Text(opt)))
                  .toList(),
              onChanged: (val) => setState(() => q.correctAnswer = val ?? ''),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz creation'),
        centerTitle: true,
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 6,
            color: theme.cardColor,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  /// Topic Input
                  TextField(
                    controller: _topicController,
                    decoration: const InputDecoration(
                      labelText: 'Enter Topic',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  /// Generate Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: isLoading ? null : generateQuiz,
                      icon: const Icon(Icons.flash_on),
                      label: isLoading
                          ? const CircularProgressIndicator()
                          : const Text('Generate Quiz'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: theme.primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  /// Question List
                  Expanded(
                    child: quizQuestions.isEmpty
                        ? const Center(child: Text('No questions yet'))
                        : ListView.builder(
                            itemCount: quizQuestions.length,
                            itemBuilder: (_, i) => _buildQuestionCard(i),
                          ),
                  ),

                  /// Bottom Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _addEmptyQuestion,
                          icon: const Icon(Icons.add),
                          label: const Text("Add Question"),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            backgroundColor: theme.primaryColor.withOpacity(0.9),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _saveQuiz,
                          icon: const Icon(Icons.save),
                          label: const Text("Save Quiz"),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            foregroundColor: theme.primaryColor,
                            side: BorderSide(color: theme.primaryColor),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
