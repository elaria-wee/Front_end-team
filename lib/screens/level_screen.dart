import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import '../models/level_theme.dart';

// Top Bar Widget
class TopBar extends StatelessWidget {
  final VoidCallback onBackPressed;
  final String levelThemeName;
  final LevelTheme theme;

  const TopBar({
    super.key,
    required this.onBackPressed,
    required this.levelThemeName,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          // Back Button
          GestureDetector(
            onTap: onBackPressed,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(Icons.arrow_back, color: theme.accentColor, size: 20),
            ),
          ),
          const Spacer(),
          // Progress Pill
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('⭐', style: GoogleFonts.fredoka(fontSize: 16)),
                  const SizedBox(width: 8),
                  Text(
                    '$COMPLETED/$TOTAL stories',
                    style: GoogleFonts.fredoka(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: theme.pillTextColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          const SizedBox(width: 44), // Spacer for alignment
        ],
      ),
    );
  }
}

// Level Title Card Widget
class LevelTitleCard extends StatelessWidget {
  final String levelId;
  final LevelTheme theme;
  final double progress;

  const LevelTitleCard({
    super.key,
    required this.levelId,
    required this.theme,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return FadeInDown(
      duration: const Duration(milliseconds: 600),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            // Icon Bubble
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: theme.iconBubbleGradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  theme.emoji,
                  style: GoogleFonts.fredoka(fontSize: 28),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Level Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Level $levelId',
                    style: GoogleFonts.fredoka(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: theme.accentColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    theme.name,
                    style: GoogleFonts.fredoka(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Progress Bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: progress / 100,
                      minHeight: 8,
                      backgroundColor: const Color(0xFFF1F5F9),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        progress > 50
                            ? theme.progressGradient[1]
                            : theme.progressGradient[0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Listening Section Widget
class ListeningSection extends StatefulWidget {
  final LevelTheme theme;
  final VoidCallback onPlayPressed;

  const ListeningSection({
    super.key,
    required this.theme,
    required this.onPlayPressed,
  });

  @override
  State<ListeningSection> createState() => _ListeningSectionState();
}

class _ListeningSectionState extends State<ListeningSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      delay: const Duration(milliseconds: 200),
      child: GestureDetector(
        onTap: widget.onPlayPressed,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: widget.theme.listeningGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.only(bottom: 24),
          child: Stack(
            children: [
              // Floating circles
              Positioned(
                top: -24,
                right: -24,
                child: Container(
                  width: 112,
                  height: 112,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.15),
                  ),
                ),
              ),
              Positioned(
                bottom: -32,
                left: -16,
                child: Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
              ),
              // Content
              Row(
                children: [
                  // Headphones Icon
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.headphones,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Text Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Audio Lesson',
                          style: GoogleFonts.fredoka(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white.withOpacity(0.8),
                            letterSpacing: 0.8,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Listening Section',
                          style: GoogleFonts.fredoka(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Listen and learn new words',
                          style: GoogleFonts.fredoka(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withOpacity(0.85),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Play Button with Pulse
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Pulse ring
                      AnimatedBuilder(
                        animation: _pulseController,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: 1 + (_pulseController.value * 0.3),
                            child: Opacity(
                              opacity: 1 - _pulseController.value,
                              child: Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withOpacity(0.4),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      // Play button
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.play_arrow,
                          color: widget.theme.playIconColor,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Story Card Widget
class StoryCard extends StatefulWidget {
  final int storyNumber;
  final String emoji;
  final LevelTheme theme;
  final StoryState state;
  final VoidCallback onTap;

  const StoryCard({
    super.key,
    required this.storyNumber,
    required this.emoji,
    required this.theme,
    required this.state,
    required this.onTap,
  });

  @override
  State<StoryCard> createState() => _StoryCardState();
}

class _StoryCardState extends State<StoryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    if (widget.state == StoryState.current) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.state != StoryState.locked ? widget.onTap : null,
      child: ScaleTransition(
        scale: widget.state == StoryState.current
            ? Tween(begin: 1.0, end: 1.05).animate(
                CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
              )
            : AlwaysStoppedAnimation(1.0),
        child: Container(
          decoration: BoxDecoration(
            color: widget.state == StoryState.completed
                ? Colors.white
                : widget.state == StoryState.current
                ? Colors.transparent
                : widget.theme.lockedBgColor,
            gradient: widget.state == StoryState.current
                ? LinearGradient(
                    colors: widget.theme.currentGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            borderRadius: BorderRadius.circular(16),
            border: widget.state == StoryState.completed
                ? Border.all(color: widget.theme.completedRingColor, width: 2)
                : widget.state == StoryState.current
                ? Border.all(color: widget.theme.currentRingColor, width: 2)
                : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Main content
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.state == StoryState.locked ? '🔒' : widget.emoji,
                      style: GoogleFonts.fredoka(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Story ${widget.storyNumber}',
                      style: GoogleFonts.fredoka(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: widget.state == StoryState.completed
                            ? const Color(0xFF475569)
                            : widget.state == StoryState.current
                            ? Colors.white
                            : widget.theme.lockedTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              // Badge
              Positioned(
                top: -6,
                right: -6,
                child: widget.state == StoryState.completed
                    ? Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: widget.theme.completedBadgeColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 14,
                        ),
                      )
                    : widget.state == StoryState.current
                    ? Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            '⭐',
                            style: GoogleFonts.fredoka(fontSize: 12),
                          ),
                        ),
                      )
                    : Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: widget.theme.lockedBadgeBgColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.lock,
                          color: widget.theme.lockedBadgeTextColor,
                          size: 12,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Encouragement Footer Widget
class EncouragementFooter extends StatelessWidget {
  final String message;
  final int storiesRemaining;

  const EncouragementFooter({
    super.key,
    required this.message,
    required this.storiesRemaining,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            message,
            style: GoogleFonts.fredoka(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$storiesRemaining more stories to unlock',
            style: GoogleFonts.fredoka(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }
}

// Floating Sticker Widget
class FloatingSticker extends StatefulWidget {
  final String emoji;

  const FloatingSticker({super.key, required this.emoji});

  @override
  State<FloatingSticker> createState() => _FloatingStickerState();
}

class _FloatingStickerState extends State<FloatingSticker>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1600),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: -12).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _animation.value),
          child: child,
        );
      },
      child: Text(widget.emoji, style: GoogleFonts.fredoka(fontSize: 28)),
    );
  }
}

// Main Level Screen
class LevelScreen extends StatefulWidget {
  final String levelId;

  const LevelScreen({super.key, required this.levelId});

  @override
  State<LevelScreen> createState() => _LevelScreenState();
}

class _LevelScreenState extends State<LevelScreen> {
  late String levelId;
  late LevelTheme theme;
  late double progress;

  @override
  void initState() {
    super.initState();
    levelId = widget.levelId;
    theme = themes[levelId] ?? themes['1']!;
    progress = (COMPLETED / TOTAL) * 100;
  }

  void handleStoryClick(int idx) {
    if (idx <= COMPLETED) {
      // Navigate to reading screen
      print('Opening story $idx');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      body: Container(
        color: theme.bgColor,
        child: SafeArea(
          child: Stack(
            children: [
              // Main scrollable content
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 20 : 32,
                    vertical: 24,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: Column(
                      children: [
                        // Top Bar
                        TopBar(
                          onBackPressed: () => Navigator.pop(context),
                          levelThemeName: levelId,
                          theme: theme,
                        ),
                        // Level Title Card
                        LevelTitleCard(
                          levelId: levelId,
                          theme: theme,
                          progress: progress,
                        ),
                        const SizedBox(height: 32),
                        // Listening Section
                        ListeningSection(
                          theme: theme,
                          onPlayPressed: () {
                            print('Play audio');
                          },
                        ),
                        // Stories Header
                        FadeInUp(
                          duration: const Duration(milliseconds: 600),
                          delay: const Duration(milliseconds: 400),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.book,
                                  color: theme.accentColor,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Stories',
                                  style: GoogleFonts.fredoka(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                    color: const Color(0xFF1E293B),
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    '$TOTAL total',
                                    style: GoogleFonts.fredoka(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: theme.pillTextColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Stories Grid
                        FadeInUp(
                          duration: const Duration(milliseconds: 600),
                          delay: const Duration(milliseconds: 500),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  mainAxisSpacing: 12,
                                  crossAxisSpacing: 12,
                                  childAspectRatio: 1,
                                ),
                            itemCount: TOTAL,
                            itemBuilder: (context, index) {
                              final storyNumber = index + 1;
                              final isCompleted = storyNumber <= COMPLETED;
                              final isCurrent = storyNumber == COMPLETED + 1;
                              final isLocked = storyNumber > COMPLETED + 1;
                              final emoji =
                                  theme.storyEmojis[index %
                                      theme.storyEmojis.length];

                              return StoryCard(
                                storyNumber: storyNumber,
                                emoji: emoji,
                                theme: theme,
                                state: isCompleted
                                    ? StoryState.completed
                                    : isCurrent
                                    ? StoryState.current
                                    : StoryState.locked,
                                onTap: () => handleStoryClick(storyNumber),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 32),
                        // Encouragement Footer
                        FadeInUp(
                          duration: const Duration(milliseconds: 600),
                          delay: const Duration(milliseconds: 600),
                          child: EncouragementFooter(
                            message: theme.encouragement,
                            storiesRemaining: TOTAL - COMPLETED,
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
              // Floating Stickers
              ...theme.stickers.asMap().entries.map((entry) {
                final index = entry.key;
                final sticker = entry.value;
                return Positioned(
                  top: sticker.top,
                  left: sticker.left,
                  right: sticker.right,
                  child: sticker.animation == 'float'
                      ? FloatingSticker(emoji: sticker.emoji)
                      : Text(
                          sticker.emoji,
                          style: GoogleFonts.fredoka(fontSize: 28),
                        ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
