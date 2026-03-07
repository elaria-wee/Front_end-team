import 'package:flutter/foundation.dart';

/// Model for a weekly score entry.
class WeeklyScoreEntry {
  const WeeklyScoreEntry({
    required this.weekLabel,
    required this.score,
    required this.date,
  });

  final String weekLabel;
  final int score;
  final String date;

  WeeklyScoreEntry copyWith({
    String? weekLabel,
    int? score,
    String? date,
  }) {
    return WeeklyScoreEntry(
      weekLabel: weekLabel ?? this.weekLabel,
      score: score ?? this.score,
      date: date ?? this.date,
    );
  }
}

/// Manages weekly scores. Calculates average automatically.
class WeeklyScoreProvider extends ChangeNotifier {
  final List<WeeklyScoreEntry> _scores = [
    const WeeklyScoreEntry(weekLabel: 'Week 1', score: 85, date: 'Feb 1–7'),
    const WeeklyScoreEntry(weekLabel: 'Week 2', score: 92, date: 'Feb 8–14'),
    const WeeklyScoreEntry(weekLabel: 'Week 3', score: 78, date: 'Feb 15–21'),
    const WeeklyScoreEntry(weekLabel: 'Week 4', score: 95, date: 'Feb 22–28'),
  ];

  List<WeeklyScoreEntry> get scores => List.unmodifiable(_scores);

  /// Average score, computed automatically.
  double get averageScore {
    if (_scores.isEmpty) return 0;
    final total = _scores.fold<int>(0, (sum, e) => sum + e.score);
    return total / _scores.length;
  }

  void addScore(WeeklyScoreEntry entry) {
    _scores.add(entry);
    notifyListeners();
  }

  void removeScore(int index) {
    if (index >= 0 && index < _scores.length) {
      _scores.removeAt(index);
      notifyListeners();
    }
  }
}
