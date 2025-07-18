class QuestionModel {
  String question;
  List<String> options; // [optionA, optionB, optionC, optionD]
  String correctAnswer; // Actual answer text (not just 'A', 'B', etc.)

  QuestionModel({
    required this.question,
    required this.options,
    required this.correctAnswer,
  });

  // Optional: Convert to Firestore-compatible Map
  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'optionA': options[0],
      'optionB': options[1],
      'optionC': options[2],
      'optionD': options[3],
      'answer': correctAnswer,
    };
  }

  // Optional: Create from Firestore document
  factory QuestionModel.fromMap(Map<String, dynamic> map) {
    return QuestionModel(
      question: map['question'] ?? '',
      options: [
        map['optionA'] ?? '',
        map['optionB'] ?? '',
        map['optionC'] ?? '',
        map['optionD'] ?? '',
      ],
      correctAnswer: map['answer'] ?? '',
    );
  }
}
