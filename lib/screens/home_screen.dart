import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/level_card.dart';
import '../widgets/main_layout.dart';
import '../data/stories_data.dart';
import './level_screen.dart';

/// Home screen for Eli's English Adventures kids learning app.
/// Matches React/Next.js design with responsive layout and animations.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _avatarFloatController;
  late AnimationController _waveBounceController;
  late AnimationController _starFloatController;
  late AnimationController _cardStaggerController;

  late Animation<double> _avatarFloat;
  late Animation<double> _waveBounce;
  late Animation<double> _starFloat;
  late Animation<double> _card1Anim;
  late Animation<double> _card2Anim;
  late Animation<double> _card3Anim;

  static const _levelBeginnerColor = Color(0xFF4A90D9);
  static const _levelExplorerColor = Color(0xFFE67E22);
  static const _levelChampionColor = Color(0xFF27AE60);
  static const _funFactAccentColor = Color(0xFFFFB74D);

  @override
  void initState() {
    super.initState();

    _avatarFloatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat(reverse: true);

    _waveBounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _starFloatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _cardStaggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _avatarFloat = Tween<double>(begin: 0, end: 8).animate(
      CurvedAnimation(parent: _avatarFloatController, curve: Curves.easeInOut),
    );

    _waveBounce = Tween<double>(begin: 0, end: 6).animate(
      CurvedAnimation(parent: _waveBounceController, curve: Curves.easeInOut),
    );

    _starFloat = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _starFloatController, curve: Curves.easeInOut),
    );

    _card1Anim = CurvedAnimation(
      parent: _cardStaggerController,
      curve: const Interval(0, 0.4, curve: Curves.easeOut),
    );
    _card2Anim = CurvedAnimation(
      parent: _cardStaggerController,
      curve: const Interval(0.2, 0.6, curve: Curves.easeOut),
    );
    _card3Anim = CurvedAnimation(
      parent: _cardStaggerController,
      curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cardStaggerController.forward();
    });
  }

  @override
  void dispose() {
    _avatarFloatController.dispose();
    _waveBounceController.dispose();
    _starFloatController.dispose();
    _cardStaggerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    final isLargeScreen = size.width >= 600;

    final avatarSize = _getResponsiveValue(
      size,
      small: 100,
      medium: 115,
      large: 130,
    );
    final titleSize = _getResponsiveValue(
      size,
      small: 22,
      medium: 24,
      large: 28,
    );
    final subtitleSize = _getResponsiveValue(
      size,
      small: 14,
      medium: 15,
      large: 16,
    );
    final horizontalPadding = size.width * 0.06;

    return MainLayout(
      selectedRoute: '/home',
      child: Container(
        color: AppColors.background,
        child: Stack(
          children: [
            SafeArea(
              top: false,
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  12,
                  horizontalPadding,
                  padding.bottom + 80,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildAvatarSection(avatarSize),
                    const SizedBox(height: 20),
                    _buildWelcomeText(context, titleSize, subtitleSize),
                    SizedBox(height: size.height * 0.03),
                    _buildLevelCards(context, size, isLargeScreen),
                    SizedBox(height: size.height * 0.025),
                    _buildFunFactCard(context, size),
                  ],
                ),
              ),
            ),
            _buildBackgroundDecorations(size, padding),
          ],
        ),
      ),
    );
  }

  double _getResponsiveValue(
    Size size, {
    required double small,
    required double medium,
    required double large,
  }) {
    if (size.width >= 900 || size.height >= 700) return large;
    if (size.width >= 400) return medium;
    return small;
  }

  Widget _buildAvatarSection(double avatarSize) {
    return AnimatedBuilder(
      animation: Listenable.merge([_avatarFloat, _waveBounce]),
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, -_avatarFloat.value),
          child: SizedBox(
            width: avatarSize,
            height: avatarSize,
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                _buildEliAvatar(avatarSize),
                Positioned(
                  right: -4,
                  bottom: -4,
                  child: Transform.translate(
                    offset: Offset(0, -_waveBounce.value),
                    child: const Text('👋', style: TextStyle(fontSize: 28)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEliAvatar(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.skyBlue.withValues(alpha: 0.25),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 12,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: AppColors.skyBlue.withValues(alpha: 0.15),
            blurRadius: 20,
            spreadRadius: -4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipOval(
        child: Image.asset(
          'assets/eli_elephant.png',
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildEliPlaceholder(size),
        ),
      ),
    );
  }

  Widget _buildEliPlaceholder(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.skyBlue.withValues(alpha: 0.3),
      ),
      child: Center(
        child: Text('🐘', style: TextStyle(fontSize: size * 0.5)),
      ),
    );
  }

  Widget _buildWelcomeText(
    BuildContext context,
    double titleSize,
    double subtitleSize,
  ) {
    return Column(
      children: [
        Text(
          'Welcome Back, Friend!',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: titleSize,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            "Choose your learning level and let's have fun with English!",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: subtitleSize,
              color: AppColors.textSecondary,
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLevelCards(BuildContext context, Size size, bool isLargeScreen) {
    final cards = [
      _AnimatedLevelCard(
        animation: _card1Anim,
        child: LevelCard(
          levelLetter: 'A',
          title: 'Beginner',
          description: 'Start your adventure with ABCs and simple words!',
          icon: Icons.star_rounded,
          themeColor: _levelBeginnerColor,
          backgroundImagePath: 'assets/level_1_background.png',
          onTap: () {
            final stories = storiesForLevel(1);
            if (stories.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('No stories found for Level 1 yet 📚'),
                  behavior: SnackBarBehavior.floating,
                  margin: EdgeInsets.only(
                    bottom: MediaQuery.of(context).padding.bottom + 16,
                    left: 16,
                    right: 16,
                  ),
                ),
              );
              return;
            }
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LevelScreen(levelId: '1'),
              ),
            );
          },
        ),
      ),
      _AnimatedLevelCard(
        animation: _card2Anim,
        child: LevelCard(
          levelLetter: 'B',
          title: 'Explorer',
          description: 'Build sentences and learn fun phrases!',
          icon: Icons.rocket_launch_rounded,
          themeColor: _levelExplorerColor,
          backgroundImagePath: 'assets/level_2_background.png',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LevelScreen(levelId: '2'),
              ),
            );
          },
        ),
      ),
      _AnimatedLevelCard(
        animation: _card3Anim,
        child: LevelCard(
          levelLetter: 'C',
          title: 'Champion',
          description: 'Master stories and become an English star!',
          icon: Icons.emoji_events_rounded,
          themeColor: _levelChampionColor,
          backgroundImagePath: 'assets/level_3_background.png',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LevelScreen(levelId: '3'),
              ),
            );
          },
        ),
      ),
    ];

    if (isLargeScreen) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: cards
            .map(
              (c) => Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: LevelCard.cardSpacing / 2,
                ),
                child: c,
              ),
            )
            .toList(),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: cards.asMap().entries.map((entry) {
        final index = entry.key;
        final card = entry.value;
        return Padding(
          padding: EdgeInsets.only(
            bottom: index < cards.length - 1 ? LevelCard.cardSpacing : 0,
          ),
          child: Center(child: card),
        );
      }).toList(),
    );
  }

  void _onLevelTapped(BuildContext context, String letter, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Level $letter Selected! Get ready for $title adventures with Eli!',
        ),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + 16,
          left: 16,
          right: 16,
        ),
      ),
    );
    // Future: Navigator.pushNamed(context, '/level/${letter.toLowerCase()}');
  }

  Widget _buildFunFactCard(BuildContext context, Size size) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: _funFactAccentColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _funFactAccentColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const Text('💡', style: TextStyle(fontSize: 28)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Fun Fact: Eli loves to read stories before bedtime!',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 14,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundDecorations(Size size, EdgeInsets padding) {
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
            animation: _starFloat,
            builder: (context, child) {
              return Positioned(
                left: 16,
                top: size.height * 0.25 + _starFloat.value,
                child: Opacity(
                  opacity: 0.35,
                  child: Text('⭐', style: TextStyle(fontSize: 32)),
                ),
              );
            },
          ),
          AnimatedBuilder(
            animation: _starFloat,
            builder: (context, child) {
              return Positioned(
                right: size.width * 0.15,
                top: size.height * 0.12 - _starFloat.value * 0.5,
                child: Opacity(
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

/// Wraps a widget with staggered fade-in and upward slide animation.
class _AnimatedLevelCard extends StatelessWidget {
  const _AnimatedLevelCard({required this.animation, required this.child});

  final Animation<double> animation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Opacity(
          opacity: animation.value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - animation.value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
