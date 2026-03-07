import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weekly_score_provider.dart';
import '../widgets/main_layout.dart';

/// Weekly score page with list of scores and automatic average calculation.
class WeeklyScorePage extends StatelessWidget {
  const WeeklyScorePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MainLayout(
      selectedRoute: '/weekly-score',
      child: SafeArea(
        child: Consumer<WeeklyScoreProvider>(
          builder: (context, provider, _) {
            final scores = provider.scores;
            final average = provider.averageScore;

            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Text(
                            'Average Score',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            average.toStringAsFixed(1),
                            style: theme.textTheme.headlineLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Weekly Scores',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.separated(
                      itemCount: scores.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final entry = scores[index];
                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor:
                                  theme.colorScheme.primaryContainer,
                              child: Icon(
                                Icons.emoji_events,
                                color: theme.colorScheme.onPrimaryContainer,
                              ),
                            ),
                            title: Text(entry.weekLabel),
                            subtitle: Text(entry.date),
                            trailing: Text(
                              '${entry.score}',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
