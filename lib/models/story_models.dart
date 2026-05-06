class Question {
  const Question({
    required this.questionText,
    required this.options,
    required this.correctAnswer,
  });

  final String questionText;
  final List<String> options;
  final String correctAnswer;
}

class Story {
  const Story({
    required this.id,
    required this.title,
    required this.text,
    required this.imagePath,
    required this.questions,
  });

  final String id;
  final String title;
  final String text;
  final String imagePath;
  final List<Question> questions;
}

