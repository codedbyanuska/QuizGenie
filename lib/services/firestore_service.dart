import 'dart:developer' as developer;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/question_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  // Fetch all quizzes with metadata
  static Future<List<Map<String, dynamic>>> fetchAllQuizzes() async {
    final snapshot = await _db
        .collection('quiz')
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'quizId': doc.id,
        'quizTitle': data['quizTitle'] ?? 'Untitled',
        'createdBy': data['createdBy'] ?? 'Unknown',
        'createdAt': data['createdAt'],
      };
    }).toList();
  }

  //  Fetch questions for a given topic
  static Future<List<QuestionModel>> fetchQuestion(String topic) async {
    final snapshot = await _db
        .collection('quiz')
        .where('quizTitle', isEqualTo: topic)
        .orderBy('createdAt', descending: true)
        .get();

    if (snapshot.docs.isEmpty) {
      print(' No quiz found for topic: $topic');
      return [];
    }

    final quizDocId = snapshot.docs.first.id;
    print('Found quiz with ID: $quizDocId');

    final questionsSnapshot = await _db
        .collection('quiz')
        .doc(quizDocId)
        .collection('questions')
        .get();

    return questionsSnapshot.docs
        .map((doc) => QuestionModel.fromMap(doc.data()))
        .toList();
  }

  //  Save new quiz with questions
  static Future<void> saveQuiz({
    required String topic,
    required String createdBy,
    required List<QuestionModel> questions,
  }) async {
    try {
      final quizDocId = '${topic}_${DateTime.now().millisecondsSinceEpoch}';
      final docRef = _db.collection('quiz').doc(quizDocId);

      await docRef.set({
        'quizId': quizDocId,
        'quizTitle': topic,
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

      developer.log(" Quiz saved with ID: $quizDocId",
          name: 'FirestoreService');
    } catch (e, stackTrace) {
      developer.log(' Error saving quiz',
          name: 'FirestoreService', error: e, stackTrace: stackTrace);
    }
  }

  //fetching user details
  static Future<String?> loginWith(String email, String password) async {
    try {
      // Sign in with Firebase Auth
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      // Get user ID
      String uid = userCredential.user!.uid;

      // Fetch user document from Firestore
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (userDoc.exists) {
        String role = userDoc['role'];

        // Return the role so you can use it in your UI to navigate
        return role; // e.g., "student" or "tutor"
      } else {
        return 'User record not found in database.';
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'Unexpected error: ${e.toString()}';
    }
  }

  //Register users with email and password
  static Future<String?> registerWithEmail(
      String email, String password, String role) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'email': email,
        'role': role,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'Unexpected error: ${e.toString()}';
    }
  }
}
