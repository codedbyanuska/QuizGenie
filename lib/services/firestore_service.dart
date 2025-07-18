import 'dart:developer' as developer;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/question_model.dart';

class FirestoreService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<void> saveQuiz({
    required String topic,
    required String createdBy,
    required List<QuestionModel> questions,
  }) async {
    try {
      // ✅ Create a new quiz document inside 'quiz'
      final docRef = await _db.collection('quiz').add({
        'topic': topic,
        'createdBy': createdBy,
        'createdAt': FieldValue.serverTimestamp(),
      });

      final questionsRef = docRef.collection('questions');

      for (int i = 0; i < questions.length; i++) {
        final q = questions[i];

        String getOption(int index) =>
            (index >= 0 && index < q.options.length) ? q.options[index] : '';

        await questionsRef.doc('q${i + 1}').set({
          'question': q.question,
          'optionA': getOption(0),
          'optionB': getOption(1),
          'optionC': getOption(2),
          'optionD': getOption(3),
          'answer': q.correctAnswer,
        });
      }

      developer.log("Quiz saved with ID: ${docRef.id}", name: 'FirestoreService');
    } catch (e, stackTrace) {
      developer.log('Error saving quiz', name: 'FirestoreService', error: e, stackTrace: stackTrace);
    }
  }
}
