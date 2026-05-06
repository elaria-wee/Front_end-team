import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_colors.dart';

class LevelPage extends StatefulWidget {
  const LevelPage({super.key});

  @override
  State<LevelPage> createState() => _LevelPageState();
}

class _LevelPageState extends State<LevelPage> with TickerProviderStateMixin {
  static const int _totalStories = 20;
  static const int _completedStories = 5;
  static const int _currentStoryNumber = _completedStories + 1; // 6

  late final AnimationController _bounceController;
  late final Animation<double> _bounce;

  // Fixed typo: removed extraneous 'z' from the icon list
  static const List<IconData> _storyIcons = [
    Icons.star,
    Icons.pets,
    Icons.emoji_nature,
    Icons.auto_awesome,
    Icons.favorite,
    Icons.cake,
  ];

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    )..repeat(reverse: true);
    _bounce = Tween<double>(begin: 0, end: 6).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  void _showNavigatingSnack(String name) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Navigating to $name...'),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: MediaQuery.paddingOf(context).bottom + 16,
          left: 16,
          right: 16,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.paddingOf(context);

    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD), // baby blue ناعم
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16, 12, 16, padding.bottom + 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _TopSection(
                completed: _completedStories,
                total: _totalStories,
                onBack: () => Navigator.pop(context),
                onOpenReading: () => _showNavigatingSnack('Beginner'),
              ),
              const SizedBox(height: 14),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1,
                ),
                itemCount: _totalStories,
                itemBuilder: (context, index) {
                  final storyNumber = index + 1;
                  final state = _StoryState.from(
                    storyNumber: storyNumber,
                    completed: _completedStories,
                    current: _currentStoryNumber,
                  );

                  // Define the emoji sources
                  const List<String> _storyEmojis = [
                    '🐶',
                    '🐱',
                    '🐭',
                    '🐹',
                    '🦊',
                    '🐻',
                  ];
                  const List<String> _genericEmojis = [
                    '📖',
                    '📚',
                    '📝',
                    '🎒',
                    '✨',
                  ];

                  final emoji = storyNumber <= 6
                      ? _storyEmojis[storyNumber - 1]
                      : _genericEmojis[(storyNumber - 7) %
                            _genericEmojis.length];

                  final canTap = storyNumber <= _completedStories;

                  return _StoryTile(
                    storyNumber: storyNumber,
                    emoji: emoji,
                    state: state,
                    bounce: _bounce,
                    onTap: canTap
                        ? () => _showNavigatingSnack('Story $storyNumber')
                        : null,
                  );
                },
              ),
              const SizedBox(height: 14),
              const _FooterCard(
                completed: _completedStories,
                total: _totalStories,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopSection extends StatelessWidget {
  const _TopSection({
    required this.completed,
    required this.total,
    required this.onBack,
    required this.onOpenReading,
  });

  final int completed;
  final int total;
  final VoidCallback onBack;
  final VoidCallback onOpenReading;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            _BackButtonPill(onBack: onBack, levelId: 1, levelName: 'Beginner'),
            const Spacer(),
            _LevelProgressPill(completed: completed, total: total),
          ],
        ),
        const SizedBox(height: 14),
        // Text(
        //   'Beginner',
        //   textAlign: TextAlign.center,
        //   style: GoogleFonts.nunito(
        //     fontWeight: FontWeight.w800,
        //     fontSize: 26,
        //     color: AppColors.darkBlue,
        //   ),
        // ),
        const SizedBox(height: 10),
        // _LevelCard is missing, so commenting it out to fix error:
        // _LevelCard(
        //   levelId: 1,
        //   levelName: 'Beginner',
        //   onTap: onOpenReading,
        // ),
        const SizedBox(height: 12),
        _AudioLessonCard(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Audio lesson coming soon! 🎧'),
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.only(
                  bottom: MediaQuery.paddingOf(context).bottom + 16,
                  left: 16,
                  right: 16,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _LevelProgressPill extends StatelessWidget {
  const _LevelProgressPill({required this.completed, required this.total});

  final int completed;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.gradientSoft.withOpacity(0.98),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_rounded,
            color: AppColors.primaryBlue,
            size: 20,
          ),
          const SizedBox(width: 7),
          Text(
            '$completed / $total stories',
            style: GoogleFonts.nunito(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: AppColors.darkBlue,
            ),
          ),
        ],
      ),
    );
  }
}

class _BackButtonPill extends StatelessWidget {
  const _BackButtonPill({
    required this.onBack,
    required this.levelId,
    required this.levelName,
  });

  final VoidCallback onBack;
  final int levelId;
  final String levelName;

  @override
  Widget build(BuildContext context) {
    return _PressScale(
      onTap: onBack,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.gradientSoft.withOpacity(0.9),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.school_rounded,
                color: AppColors.primaryBlue,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'LEVEL : $levelId',
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      color: AppColors.darkBlue,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$levelName',
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      color: AppColors.darkBlue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const _LevelProgressBar(progress: 0.25),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LevelProgressBar extends StatelessWidget {
  const _LevelProgressBar({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: SizedBox(
        height: 10,
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                color: AppColors.gradientSoft.withValues(alpha: 0.7),
              ),
            ),
            FractionallySizedBox(
              widthFactor: progress.clamp(0, 1),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.skyBlue.withValues(alpha: 0.9),
                      const Color(0xFF27AE60).withValues(alpha: 0.9),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AudioLessonCard extends StatelessWidget {
  const _AudioLessonCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _PressScale(
      onTap: onTap,
      child: Container(
        height: 108,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primaryBlue.withValues(alpha: 0.95),
              AppColors.skyBlue.withValues(alpha: 0.85),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryBlue.withValues(alpha: 0.22),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              Positioned(
                left: -28,
                top: -20,
                child: _Blob(size: 86, opacity: 0.16),
              ),
              Positioned(
                right: -34,
                bottom: -24,
                child: _Blob(size: 110, opacity: 0.12),
              ),
              Positioned(
                left: 88,
                bottom: -30,
                child: _Blob(size: 90, opacity: 0.10),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Icon(
                        Icons.headphones_rounded,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Listening Section',
                            style: GoogleFonts.nunito(
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Listen & learn',
                            style: GoogleFonts.nunito(
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                              color: Colors.white.withValues(alpha: 0.92),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.play_arrow_rounded,
                        color: AppColors.primaryBlue,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Blob extends StatelessWidget {
  const _Blob({required this.size, required this.opacity});

  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: opacity),
        borderRadius: BorderRadius.circular(size),
      ),
    );
  }
}

enum _StoryState {
  completed,
  current,
  locked;

  static _StoryState from({
    required int storyNumber,
    required int completed,
    required int current,
  }) {
    if (storyNumber <= completed) return _StoryState.completed;
    if (storyNumber == current) return _StoryState.current;
    return _StoryState.locked;
  }
}

class _StoryTile extends StatelessWidget {
  const _StoryTile({
    required this.storyNumber,
    required this.emoji,
    required this.state,
    required this.bounce,
    required this.onTap,
  });

  final int storyNumber;
  final String emoji;
  final _StoryState state;
  final Animation<double> bounce;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(24);

    final canTap = onTap != null;

    Color bg;
    Gradient? gradient;
    Color border;
    double opacity = 1;

    Widget badge;

    switch (state) {
      case _StoryState.completed:
        bg = Colors.white.withValues(alpha: 0.95);
        border = const Color(
          0xFF00C853,
        ); // Added missing semicolon to fix error
        badge = _Badge(
          background: const Color(0xFF10B981).withValues(alpha: 0.15),
          child: const Icon(
            Icons.check_rounded,
            size: 16,
            color: Color(0xFF10B981),
          ),
        );
        break;
      case _StoryState.current:
        bg = Colors.transparent;
        gradient = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFF59E0B).withValues(alpha: 0.95),
            const Color(0xFFF97316).withValues(alpha: 0.92),
          ],
        );
        border = Colors.white.withValues(alpha: 0.45);
        badge = _Badge(
          background: Colors.white.withValues(alpha: 0.22),
          child: const Text('⭐', style: TextStyle(fontSize: 14)),
        );
        break;
      case _StoryState.locked:
        bg = AppColors.gradientSoft.withValues(alpha: 0.85);
        border = AppColors.gradientLight.withValues(alpha: 0.5);
        opacity = 0.62;
        badge = _Badge(
          background: Colors.white.withValues(alpha: 0.35),
          child: Icon(
            Icons.lock_rounded,
            size: 16,
            color: AppColors.darkBlue.withValues(alpha: 0.7),
          ),
        );
        break;
    }

    Widget tile = Container(
      decoration: BoxDecoration(
        borderRadius: radius,
        color: gradient == null ? bg : null,
        gradient: gradient,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
          if (state == _StoryState.current)
            BoxShadow(
              color: const Color(0xFFF59E0B).withValues(alpha: 0.28),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
        ],
        border: Border.all(color: border, width: 1.4),
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: Stack(
          children: [
            Positioned(left: 10, top: 10, child: badge),
            Center(
              child: Opacity(
                opacity: 0.98,
                child: Text(emoji, style: const TextStyle(fontSize: 28)),
              ),
            ),
            Positioned(
              right: 10,
              bottom: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.75),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '$storyNumber',
                  style: GoogleFonts.nunito(
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                    color: AppColors.darkBlue,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    if (state == _StoryState.current) {
      tile = AnimatedBuilder(
        animation: bounce,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, -bounce.value),
            child: child,
          );
        },
        child: tile,
      );
    }

    tile = Opacity(opacity: opacity, child: tile);

    if (!canTap) return tile;

    return _PressScale(onTap: onTap, child: tile);
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.background, required this.child});

  final Color background;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(child: child),
    );
  }
}

class _FooterCard extends StatelessWidget {
  const _FooterCard({required this.completed, required this.total});

  final int completed;
  final int total;

  @override
  Widget build(BuildContext context) {
    final remaining = math.max(0, total - completed);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Keep going, superstar! 💙',
            style: GoogleFonts.nunito(
              fontWeight: FontWeight.w800,
              fontSize: 16,
              color: AppColors.darkBlue,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$remaining more stories to unlock',
            style: GoogleFonts.nunito(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _PressScale extends StatefulWidget {
  const _PressScale({required this.child, required this.onTap});

  final Widget child;
  final VoidCallback? onTap;

  @override
  State<_PressScale> createState() => _PressScaleState();
}

class _PressScaleState extends State<_PressScale> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onTap != null;
    return Listener(
      onPointerDown: enabled ? (_) => setState(() => _pressed = true) : null,
      onPointerUp: enabled ? (_) => setState(() => _pressed = false) : null,
      onPointerCancel: enabled ? (_) => setState(() => _pressed = false) : null,
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 110),
        curve: Curves.easeOut,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(24),
          splashColor: Colors.white.withOpacity(0.15),
          highlightColor: Colors.transparent,
          child: widget.child,
        ),
      ),
    );
  }
}
