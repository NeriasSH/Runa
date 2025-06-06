// models/trivia_model.dart
class Trivia {
  final String topic;
  final List<TriviaQuestion> questions;

  Trivia({required this.topic, required this.questions});

  factory Trivia.fromJson(Map<String, dynamic> json) {
    return Trivia(
      topic: json['topic'] as String? ?? 'Tema desconocido',
      questions: (json['questions'] as List)
          .map((q) => TriviaQuestion.fromJson(q))
          .toList(),
    );
  }
}

class TriviaQuestion {
  final String text;
  final List<TriviaOption> options;

  TriviaQuestion({required this.text, required this.options});

  factory TriviaQuestion.fromJson(Map<String, dynamic> json) {
    return TriviaQuestion(
      text: json['text'] as String? ?? 'Pregunta sin texto',
      options: (json['options'] as List)
          .map((o) => TriviaOption.fromJson(o))
          .toList(),
    );
  }
}

class TriviaOption {
  final String text;
  final bool isCorrect;

  TriviaOption({required this.text, required this.isCorrect});

  factory TriviaOption.fromJson(Map<String, dynamic> json) {
    return TriviaOption(
      text: json['text'] as String? ?? 'Opción no disponible',
      isCorrect: json['isCorrect'] as bool? ?? false,
    );
  }
}
