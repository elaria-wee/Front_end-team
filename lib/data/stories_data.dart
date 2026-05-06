import '../models/story_models.dart';

/// Flutter-native, local story data.
///
/// This replaces any Excel-at-runtime approach. Keep it simple for now:
/// - Store data in Dart (or later move to JSON assets if needed).
///
/// Add your real Level 1/2/3 stories here.
final Map<int, List<Story>> storiesByLevel = {
  1: const [
    Story(
      id: 'l1_s1',
      title: 'Eli and the Star',
      text:
          'Eli the elephant sees a little star in the sky. ⭐\n\nHe smiles and says, "Hello, star!"\n\nThe star twinkles back. Eli feels happy and brave.',
      imagePath: 'assets/eli-with-book.png',
      questions: [
        Question(
          questionText: 'Who is the main character?',
          options: ['Eli', 'A lion', 'A robot'],
          correctAnswer: 'Eli',
        ),
        Question(
          questionText: 'What does Eli see in the sky?',
          options: ['A star', 'A train', 'A banana'],
          correctAnswer: 'A star',
        ),
        Question(
          questionText: 'How does Eli feel?',
          options: ['Happy', 'Angry', 'Sleepy'],
          correctAnswer: 'Happy',
        ),
      ],
    ),
    Story(
      id: 'l1_s2',
      title: 'The Magic Word',
      text:
          'Eli learns a magic word: "Please".\n\nWhen Eli says "Please", friends help him.\n\nEli says, "Please and thank you!"',
      imagePath: 'assets/eli_elephant.png',
      questions: [
        Question(
          questionText: 'What is the magic word?',
          options: ['Please', 'No', 'Bye'],
          correctAnswer: 'Please',
        ),
        Question(
          questionText: 'What does Eli say after "Please"?',
          options: ['Thank you', 'Never', 'Nothing'],
          correctAnswer: 'Thank you',
        ),
        Question(
          questionText: 'What happens when Eli says "Please"?',
          options: ['Friends help him', 'It rains', 'He flies'],
          correctAnswer: 'Friends help him',
        ),
      ],
    ),
  ],
};

List<Story> storiesForLevel(int levelId) => storiesByLevel[levelId] ?? const [];

