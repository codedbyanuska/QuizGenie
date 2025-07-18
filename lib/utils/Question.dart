class Question {
  String question, optionA, optionB, optionC, optionD, answer;
  Question(
      {required this.question,
      required this.optionA,
      required this.optionB,
      required this.optionC,
      required this.optionD,
      required this.answer});

  factory Question.fromMap(Map<String, dynamic> data) {
    return Question(
        question: data['question'] ?? '',
        optionA: data['optionA'] ?? '',
        optionB: data['optionB'] ?? '',
        optionC: data['optionC'] ?? '',
        optionD: data['optionD'] ?? '',
        answer: data['answer'] ?? '');
  }
}
