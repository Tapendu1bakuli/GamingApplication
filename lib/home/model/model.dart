class Answer {
  final int id;
  final String answer;

  Answer({required this.id, required this.answer});

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      id: json['id'],
      answer: json['answer'],
    );
  }
}

class Question {
  final String question;
  final List<Answer> answers;
  final int correctAnswerId;

  Question({required this.question, required this.answers, required this.correctAnswerId});

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      question: json['question'],
      answers: (json['answers'] as List).map((i) => Answer.fromJson(i)).toList(),
      correctAnswerId: json['correctAnswerId'],
    );
  }
}
