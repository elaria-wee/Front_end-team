import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/ai_story_provider.dart';
import '../widgets/main_layout.dart';

/// AI story generation page. Prepared for API integration.
class AiStoryPage extends StatelessWidget {
  const AiStoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      selectedRoute: '/ai-story',
      child: SafeArea(
        child: Consumer<AiStoryProvider>(
          builder: (context, provider, _) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Enter a prompt to generate your story',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'e.g., A magical elephant who loves to read...',
                      border: const OutlineInputBorder(),
                      filled: true,
                      fillColor: Theme.of(context)
                          .colorScheme
                          .surfaceContainerHighest
                          .withValues(alpha: 0.5),
                    ),
                    onChanged: provider.setPrompt,
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: provider.isLoading ? null : provider.generateStory,
                    icon: provider.isLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          )
                        : const Icon(Icons.auto_stories),
                    label: Text(provider.isLoading ? 'Generating...' : 'Generate'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                  if (provider.error != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      provider.error!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.error,
                          ),
                    ),
                  ],
                  if (provider.generatedStory.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest
                                .withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Theme.of(context)
                                  .colorScheme
                                  .outline
                                  .withValues(alpha: 0.3),
                            ),
                          ),
                          child: Text(
                            provider.generatedStory,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
