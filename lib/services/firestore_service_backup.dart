import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quizgenie/utils/Question.dart';

Future<List<Question>> fetch() async {
  final snapshot = await FirebaseFirestore.instance
      .collection('quiz')
      .doc('NumberofProjects')
      .collection('questions')
      .get();
  return snapshot.docs.map((doc) => Question.fromMap(doc.data())).toList();
}
