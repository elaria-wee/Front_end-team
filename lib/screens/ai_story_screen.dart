import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// AI Story screen for kids learning app.
/// Create your own story with Eli!
class AIStoryScreen extends StatefulWidget {
  const AIStoryScreen({super.key});

  @override
  State<AIStoryScreen> createState() => _AIStoryScreenState();
}

class _AIStoryScreenState extends State<AIStoryScreen>
    with TickerProviderStateMixin {
  static const Color _accentPurple = Color(0xFF9C6BFF);
  static const Color _eliPastel = Color(0xFFF0F4FF);

  late final TextEditingController _storyController;
  late final AnimationController _floatController;
  late final Animation<double> _floatAnimation;
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  final List<_QuickPrompt> _quickPrompts = const [
    _QuickPrompt(emoji: '🦁', label: 'Jungle Adventure', text: 'Tell me a jungle adventure story!'),
    _QuickPrompt(emoji: '🚀', label: 'Space Journey', text: 'Tell me a space journey story!'),
    _QuickPrompt(emoji: '🧙', label: 'Magic Kingdom', text: 'Tell me a magic kingdom story!'),
    _QuickPrompt(emoji: '🐠', label: 'Ocean Explorer', text: 'Tell me an ocean explorer story!'),
  ];

  @override
  void initState() {
    super.initState();
    _storyController = TextEditingController();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    _floatAnimation = Tween<double>(begin: 0, end: 6).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.85, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _storyController.dispose();
    _floatController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _onGeneratePressed() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Eli is creating your story! 📖✨'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor: AppColors.gradientSoft.withValues(alpha: 0.5),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTopAppBar(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildEliHelperSection(context),
                    const SizedBox(height: 24),
                    _buildHeader(context),
                    const SizedBox(height: 20),
                    _buildStoryInputCard(context),
                    const SizedBox(height: 20),
                    _buildQuickPromptsGrid(context, width),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopAppBar(BuildContext context) {
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
              onTap: () => Navigator.pop(context),
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
          const SizedBox(width: 16),
          Expanded(
            child: Center(
              child: Text(
                'AI Story Magic',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryBlue,
                      fontSize: 20,
                    ),
              ),
            ),
          ),
          const SizedBox(width: 44),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primaryBlue, _accentPurple.withValues(alpha: 0.9)],
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryBlue.withValues(alpha: 0.35),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) => Transform.scale(
                  scale: _pulseAnimation.value,
                  child: child,
                ),
                child: const Icon(Icons.auto_awesome, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 8),
              Text(
                'AI Story Magic ✨',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(width: 8),
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) => Transform.scale(
                  scale: _pulseAnimation.value,
                  child: child,
                ),
                child: const Icon(Icons.auto_awesome, color: Colors.white, size: 18),
              ),
            ],
          ),
        ),
          const SizedBox(height: 16),
          Text(
              'Create Your Own Story!',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkBlue,
                  fontSize: 24,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tell Eli what story you want and magic will happen!',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 15,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoryInputCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.auto_fix_high_rounded, color: _accentPurple, size: 24),
              const SizedBox(width: 10),
              Text(
                'What story would you like?',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkBlue,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _storyController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Example: A brave little cat who learns to fly...',
              filled: true,
              fillColor: AppColors.gradientSoft.withValues(alpha: 0.3),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: _onGeneratePressed,
            icon: const Icon(Icons.auto_awesome, size: 22),
            label: const Text('Generate Story!'),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickPromptsGrid(BuildContext context, double width) {
    final crossAxisCount = width >= 600 ? 4 : 2;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick story ideas',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.darkBlue,
              ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: crossAxisCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: width < 400 ? 1.3 : 1.5,
          children: _quickPrompts.map((p) => _buildQuickPromptButton(context, p)).toList(),
        ),
      ],
    );
  }

  Widget _buildQuickPromptButton(BuildContext context, _QuickPrompt prompt) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            _storyController.text = prompt.text;
          },
          splashColor: AppColors.gradientLight.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Text(prompt.emoji, style: const TextStyle(fontSize: 32)),
              const SizedBox(height: 8),
              Text(
                prompt.label,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkBlue,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEliHelperSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _eliPastel,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedBuilder(
            animation: _floatAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, -_floatAnimation.value),
                child: child,
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/eli-with-book.png',
                width: 64,
                height: 64,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 64,
                  height: 64,
                  color: AppColors.gradientLight,
                  child: const Center(child: Text('🐘', style: TextStyle(fontSize: 32))),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Eli says:',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryBlue,
                        fontSize: 15,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  '"I love reading stories with you!\nLet\'s create something magical together!"',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.darkBlue,
                        height: 1.4,
                        fontSize: 15,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickPrompt {
  const _QuickPrompt({
    required this.emoji,
    required this.label,
    required this.text,
  });

  final String emoji;
  final String label;
  final String text;
}
