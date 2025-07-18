import 'dart:convert';
import 'package:http/http.dart' as http;

class TogetherAIService {
  static const String apiKey = '884c4a9bc59098fc8a31347774c4524c57af15346ca28ad11297e65ae740d33e';
  static const String endpoint = 'https://api.together.xyz/v1/chat/completions';
  static const String model = 'mistralai/Mistral-7B-Instruct-v0.2';

  static Future<String> generateQuiz(String topic) async {
    final prompt = '''
You are a quiz generator.
Generate 5 multiple-choice questions about "$topic".
Each question must have 4 options (A–D) and mention the correct answer.

Format:
Q1. Question
A. Option 1
B. Option 2
C. Option 3
D. Option 4
Answer: B
''';

    final headers = {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      "model": model,
      "messages": [
        {"role": "system", "content": "You are a helpful quiz assistant."},
        {"role": "user", "content": prompt}
      ],
      "temperature": 0.7,
      "max_tokens": 512
    });

    final response = await http.post(Uri.parse(endpoint), headers: headers, body: body);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final content = json['choices'][0]['message']['content'];
      return content;
    } else {
      throw Exception('Error: ${response.statusCode}\n${response.body}');
    }
  }
}
