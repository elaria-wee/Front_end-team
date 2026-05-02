import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../data/reading_stories.dart';
import '../models/reading_models.dart';
import '../theme/app_colors.dart';

enum _ReadingPage {
  story,
  questions,
}

/// Reading experience (Story + Questions) that matches the app’s existing
/// child-friendly Level UI style.
class ReadingScreen extends StatefulWidget {
  const ReadingScreen({
    super.key,
    this.initialStoryIndex = 0,
  });

  final int initialStoryIndex;

  @override
  State<ReadingScreen> createState() => _ReadingScreenState();
}

class _ReadingScreenState extends State<ReadingScreen>
    with TickerProviderStateMixin {
  late int _storyIndex;
  _ReadingPage _page = _ReadingPage.story;

  // Per-question states.
  final Map<int, int?> _selectedOption = {};
  final Set<int> _correctQuestions = {};
  final Map<int, bool> _showTryAgain = {};

  late final AnimationController _fadeController;
  late final Animation<double> _fadeIn;

  late final AnimationController _stickerFloatController;
  late final Animation<double> _stickerFloat;

  late final AnimationController _celebrateController;
  late final Animation<double> _celebrateScale;

  @override
  void initState() {
    super.initState();
    _storyIndex = widget.initialStoryIndex.clamp(0, readingStories.length - 1);

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _fadeIn = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);

    _stickerFloatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    _stickerFloat = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(
        parent: _stickerFloatController,
        curve: Curves.easeInOut,
      ),
    );

    _celebrateController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    _celebrateScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.08)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 55,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.08, end: 1.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 45,
      ),
    ]).animate(_celebrateController);

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _stickerFloatController.dispose();
    _celebrateController.dispose();
    super.dispose();
  }

  ReadingStory get _story => readingStories[_storyIndex];

  int get _totalStories => 20; // UI requirement (Story X of 20).

  bool get _allCorrect =>
      _story.questions.isNotEmpty &&
      _correctQuestions.length == _story.questions.length;

  void _goToQuestions() {
    setState(() => _page = _ReadingPage.questions);
    _restartPageAnimations();
  }

  void _goBackToStory() {
    setState(() => _page = _ReadingPage.story);
    _restartPageAnimations();
  }

  void _restartPageAnimations() {
    _fadeController
      ..reset()
      ..forward();
  }

  void _resetForNewStory() {
    _selectedOption.clear();
    _correctQuestions.clear();
    _showTryAgain.clear();
    _page = _ReadingPage.story;
    _restartPageAnimations();
  }

  void _onOptionTap(int questionIndex, int optionIndex) {
    final q = _story.questions[questionIndex];
    final isCorrect = optionIndex == q.correctAnswerIndex;

    setState(() {
      _selectedOption[questionIndex] = optionIndex;
      _showTryAgain[questionIndex] = !isCorrect;
      if (isCorrect) {
        _correctQuestions.add(questionIndex);
      } else {
        _correctQuestions.remove(questionIndex);
      }
    });

    if (isCorrect) {
      _celebrateController
        ..reset()
        ..forward();
    }
  }

  void _goNextStory() {
    if (!_allCorrect) return;
    if (_storyIndex >= readingStories.length - 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('You finished all stories! 🌟'),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(
            bottom: MediaQuery.paddingOf(context).bottom + 16,
            left: 16,
            right: 16,
          ),
        ),
      );
      return;
    }

    setState(() => _storyIndex += 1);
    _resetForNewStory();
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.paddingOf(context);
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: AppColors.gradientSoft.withValues(alpha: 0.65),
      body: SafeArea(
        child: Stack(
          children: [
            _buildBackgroundDecorations(size, padding),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _TopBar(
                  title: _page == _ReadingPage.story ? 'Reading Time' : 'Quick Quiz',
                  progressText: 'Story ${_storyIndex + 1} of $_totalStories',
                  onBack: () {
                    if (_page == _ReadingPage.questions) {
                      _goBackToStory();
                    } else {
                      Navigator.pop(context);
                    }
                  },
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, padding.bottom + 24),
                    child: FadeTransition(
                      opacity: _fadeIn,
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 520),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 220),
                            switchInCurve: Curves.easeOut,
                            switchOutCurve: Curves.easeIn,
                            child: _page == _ReadingPage.story
                                ? _StoryView(
                                    key: ValueKey('story-${_story.id}'),
                                    story: _story,
                                    stickerFloat: _stickerFloat,
                                    onNext: _goToQuestions,
                                  )
                                : _QuestionsView(
                                    key: ValueKey('questions-${_story.id}'),
                                    story: _story,
                                    selectedOption: _selectedOption,
                                    correctQuestions: _correctQuestions,
                                    showTryAgain: _showTryAgain,
                                    celebrateScale: _celebrateScale,
                                    onOptionTap: _onOptionTap,
                                    allCorrect: _allCorrect,
                                    onNextStory: _goNextStory,
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundDecorations(Size size, EdgeInsets padding) {
    // Reuses the same decoration vibe as HomeScreen (floating stars + book emoji).
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            right: 12,
            bottom: padding.bottom + 20,
            child: Opacity(
              opacity: 0.25,
              child: Text('📚', style: TextStyle(fontSize: size.width * 0.12)),
            ),
          ),
          AnimatedBuilder(
            animation: _stickerFloat,
            builder: (context, child) {
              return Positioned(
                left: 16,
                top: size.height * 0.26 + _stickerFloat.value,
                child: const Opacity(
                  opacity: 0.35,
                  child: Text('⭐', style: TextStyle(fontSize: 32)),
                ),
              );
            },
          ),
          AnimatedBuilder(
            animation: _stickerFloat,
            builder: (context, child) {
              return Positioned(
                right: size.width * 0.15,
                top: size.height * 0.14 - _stickerFloat.value * 0.5,
                child: const Opacity(
                  opacity: 0.2,
                  child: Text('🌟', style: TextStyle(fontSize: 28)),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.title,
    required this.progressText,
    required this.onBack,
  });

  final String title;
  final String progressText;
  final VoidCallback onBack;

  static const Color _eliPastel = Color(0xFFF0F4FF);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Material(
            color: _eliPastel.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(24),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onBack,
              borderRadius: BorderRadius.circular(24),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Icon(
                  Icons.arrow_back,
                  color: AppColors.darkBlue,
                  size: 24,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryBlue,
                        fontSize: 18,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  progressText,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 44),
        ],
      ),
    );
  }
}

class _StoryView extends StatelessWidget {
  const _StoryView({
    super.key,
    required this.story,
    required this.stickerFloat,
    required this.onNext,
  });

  final ReadingStory story;
  final Animation<double> stickerFloat;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        _Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  story.title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: AppColors.darkBlue,
                        fontSize: 22,
                      ),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    story.text,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: 18,
                          height: 1.5,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                const SizedBox(height: 18),
                _PrimaryButton(
                  label: 'Next',
                  icon: Icons.arrow_forward_rounded,
                  onTap: onNext,
                ),
              ],
            ),
          ),
        ),
        Positioned(
          right: -6,
          top: -10,
          child: AnimatedBuilder(
            animation: stickerFloat,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, -stickerFloat.value),
                child: Transform.rotate(
                  angle: -0.08 + math.sin(stickerFloat.value / 12) * 0.03,
                  child: child,
                ),
              );
            },
            child: _StickerImage(assetPath: story.imageAssetPath),
          ),
        ),
      ],
    );
  }
}

class _QuestionsView extends StatelessWidget {
  const _QuestionsView({
    super.key,
    required this.story,
    required this.selectedOption,
    required this.correctQuestions,
    required this.showTryAgain,
    required this.celebrateScale,
    required this.onOptionTap,
    required this.allCorrect,
    required this.onNextStory,
  });

  final ReadingStory story;
  final Map<int, int?> selectedOption;
  final Set<int> correctQuestions;
  final Map<int, bool> showTryAgain;
  final Animation<double> celebrateScale;
  final void Function(int questionIndex, int optionIndex) onOptionTap;
  final bool allCorrect;
  final VoidCallback onNextStory;

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: celebrateScale,
                  builder: (context, child) {
                    return Transform.scale(scale: celebrateScale.value, child: child);
                  },
                  child: Icon(
                    allCorrect ? Icons.emoji_events_rounded : Icons.quiz_rounded,
                    color: allCorrect ? const Color(0xFF27AE60) : AppColors.primaryBlue,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  allCorrect ? 'Great job!' : 'Answer all questions',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkBlue,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            ...List.generate(story.questions.length, (index) {
              final q = story.questions[index];
              final selected = selectedOption[index];
              final isCorrect = correctQuestions.contains(index);
              final showWrong = showTryAgain[index] == true && selected != null && !isCorrect;
              return Padding(
                padding: EdgeInsets.only(bottom: index == story.questions.length - 1 ? 0 : 16),
                child: _QuestionCard(
                  index: index,
                  question: q,
                  selected: selected,
                  isCorrect: isCorrect,
                  showWrong: showWrong,
                  onOptionTap: (optionIndex) => onOptionTap(index, optionIndex),
                ),
              );
            }),
            const SizedBox(height: 18),
            _PrimaryButton(
              label: allCorrect ? 'Next Story' : 'Next Story',
              icon: Icons.arrow_forward_rounded,
              onTap: allCorrect ? onNextStory : null,
              big: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _QuestionCard extends StatelessWidget {
  const _QuestionCard({
    required this.index,
    required this.question,
    required this.selected,
    required this.isCorrect,
    required this.showWrong,
    required this.onOptionTap,
  });

  final int index;
  final ReadingQuestion question;
  final int? selected;
  final bool isCorrect;
  final bool showWrong;
  final ValueChanged<int> onOptionTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(
          color: isCorrect
              ? const Color(0xFF27AE60).withValues(alpha: 0.35)
              : showWrong
                  ? const Color(0xFFE57373).withValues(alpha: 0.35)
                  : AppColors.gradientLight.withValues(alpha: 0.35),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 30,
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.gradientSoft.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${index + 1}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: AppColors.darkBlue,
                      ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  question.text,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: AppColors.darkBlue,
                        height: 1.35,
                      ),
                ),
              ),
              const SizedBox(width: 8),
              if (isCorrect)
                const Text('✅', style: TextStyle(fontSize: 20))
              else if (showWrong)
                const Text('❗', style: TextStyle(fontSize: 20)),
            ],
          ),
          const SizedBox(height: 10),
          ...List.generate(question.options.length, (optionIndex) {
            final option = question.options[optionIndex];
            final isSelected = selected == optionIndex;
            final isOptionCorrect = optionIndex == question.correctAnswerIndex;

            Color bg = Colors.white;
            Color border = AppColors.gradientLight.withValues(alpha: 0.55);
            Color text = AppColors.darkBlue;

            if (isSelected && isCorrect && isOptionCorrect) {
              bg = const Color(0xFF27AE60).withValues(alpha: 0.14);
              border = const Color(0xFF27AE60).withValues(alpha: 0.45);
              text = const Color(0xFF1B5E20);
            } else if (isSelected && showWrong && !isOptionCorrect) {
              bg = const Color(0xFFE57373).withValues(alpha: 0.14);
              border = const Color(0xFFE57373).withValues(alpha: 0.45);
              text = const Color(0xFFB71C1C);
            }

            return Padding(
              padding: EdgeInsets.only(bottom: optionIndex == question.options.length - 1 ? 0 : 10),
              child: _AnswerButton(
                label: option,
                background: bg,
                borderColor: border,
                textColor: text,
                onTap: isCorrect ? null : () => onOptionTap(optionIndex),
              ),
            );
          }),
          if (showWrong) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                const Text('Try again ', style: TextStyle(fontSize: 15)),
                Text(
                  '😊',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 18),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _StickerImage extends StatelessWidget {
  const _StickerImage({required this.assetPath});

  final String assetPath;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 74,
      height: 74,
      decoration: BoxDecoration(
        color: AppColors.gradientSoft.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(
          color: AppColors.gradientLight.withValues(alpha: 0.45),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Image.asset(
          assetPath,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) {
            return Center(
              child: Text(
                '⭐',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 30),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.big = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onTap;
  final bool big;

  @override
  Widget build(BuildContext context) {
    return _PressScale(
      enabled: onTap != null,
      child: FilledButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: big ? 24 : 22),
        label: Text(label),
        style: FilledButton.styleFrom(
          backgroundColor: onTap == null
              ? AppColors.primaryBlue.withValues(alpha: 0.45)
              : AppColors.primaryBlue,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: big ? 18 : 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          elevation: 4,
        ),
      ),
    );
  }
}

class _PressScale extends StatefulWidget {
  const _PressScale({required this.child, required this.enabled});

  final Widget child;
  final bool enabled;

  @override
  State<_PressScale> createState() => _PressScaleState();
}

class _PressScaleState extends State<_PressScale> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.enabled ? (_) => setState(() => _pressed = true) : null,
      onTapUp: widget.enabled ? (_) => setState(() => _pressed = false) : null,
      onTapCancel: widget.enabled ? () => setState(() => _pressed = false) : null,
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 110),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}

class _AnswerButton extends StatelessWidget {
  const _AnswerButton({
    required this.label,
    required this.background,
    required this.borderColor,
    required this.textColor,
    required this.onTap,
  });

  final String label;
  final Color background;
  final Color borderColor;
  final Color textColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        splashColor: AppColors.gradientLight.withValues(alpha: 0.6),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: borderColor, width: 1),
          ),
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
          ),
        ),
      ),
    );
  }
}

