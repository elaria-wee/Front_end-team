import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'signin_screen.dart';
import 'signup_screen.dart';

/// Welcome Screen for Eli's English Adventures
/// Features a jungle classroom theme with animated mascot and modern UI
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _mascotController;
  late AnimationController _buttonController;
  late Animation<double> _mascotAnimation;
  late Animation<double> _buttonAnimation;

  @override
  void initState() {
    super.initState();

    // Mascot floating animation
    _mascotController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _mascotAnimation = Tween<double>(begin: 0.0, end: 0.1).animate(
      CurvedAnimation(parent: _mascotController, curve: Curves.easeInOut),
    );

    // Button bounce animation
    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _buttonAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeInOut),
    );

    // Start mascot animation
    _mascotController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _mascotController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // ✅ Corrected asset path and used your image
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/jungle-classroom.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Container(
            decoration: BoxDecoration(color: AppColors.overlayBlue),
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),

                    _buildAnimatedMascot(),

                    const SizedBox(height: 40),

                    _buildWelcomeTitle(),

                    const SizedBox(height: 60),

                    _buildSignInButton(),

                    const SizedBox(height: 20),

                    _buildSignUpButton(),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedMascot() {
    return AnimatedBuilder(
      animation: _mascotAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, -10 * _mascotAnimation.value),
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(100),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowMedium,
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.asset(
                'assets/eli_elephant.png',
                width: 180,
                height: 180,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildEliPlaceholder();
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEliPlaceholder() {
    return Container(
      width: 180,
      height: 180,
      decoration: BoxDecoration(
        color: AppColors.skyBlue,
        borderRadius: BorderRadius.circular(90),
      ),
      child: const Center(
        child: Text('🐘', style: TextStyle(fontSize: 80)),
      ),
    );
  }

  Widget _buildWelcomeTitle() {
    return Column(
      children: [
        Text(
          'Welcome to',
          style: AppTextStyles.welcomeTitle,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          "Eli's English Adventures!",
          style: AppTextStyles.welcomeSubtitle,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSignInButton() {
    return AnimatedBuilder(
      animation: _buttonAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _buttonAnimation.value,
          child: SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              onPressed: () {
                _buttonController.forward().then((_) {
                  _buttonController.reverse();
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignInScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.signInButton,
                foregroundColor: AppColors.textOnOrange,
                elevation: 8,
                shadowColor: AppColors.shadowMedium,
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(vertical: 20),
              ),
              child: Text('Sign In', style: AppTextStyles.signInButton),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSignUpButton() {
    return AnimatedBuilder(
      animation: _buttonAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _buttonAnimation.value,
          child: SizedBox(
            width: double.infinity,
            height: 60,
            child: OutlinedButton(
              onPressed: () {
                _buttonController.forward().then((_) {
                  _buttonController.reverse();
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpScreen()),
                );
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: AppColors.signUpButtonBackground,
                foregroundColor: AppColors.textOnBlue,
                side: const BorderSide(
                  color: AppColors.signUpButtonBorder,
                  width: 4,
                ),
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(vertical: 20),
              ),
              child: Text('Sign Up', style: AppTextStyles.signUpButton),
            ),
          ),
        );
      },
    );
  }
}
