import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'signup_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _showPassword = false;
  bool _isPressingButton = false;
  late final AnimationController _eliBounceController;
  late final Animation<double> _eliScale;

  static const Color primarySkyBlue = Color(0xFF4FC3F7);
  static const Color accentWarmOrange = Color(0xFFFFB74D);
  static const Color textNavy = Color(0xFF1F2937);

  @override
  void initState() {
    super.initState();
    _eliBounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
    _eliScale = Tween<double>(begin: 0.98, end: 1.02)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(_eliBounceController);
  }

  @override
  void dispose() {
    _eliBounceController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ✅ Added missing helper
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  void _showToast(String message, {bool success = false}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: success ? Colors.green.shade600 : Colors.red.shade600,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void _validateEmailOnFocus() {
    final email = _emailController.text.trim();
    if (email.isNotEmpty && !_isValidEmail(email)) {
      _showToast('Please enter a valid email address!');
    }
  }

  void _onSubmit() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showToast('Please fill in all fields!');
      return;
    }
    if (!_isValidEmail(email)) {
      _showToast('Please enter a valid email address!');
      return;
    }

    _showToast("Welcome back! Let's learn with Eli!", success: true);
    Navigator.pushNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE1F5FE), Colors.white],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: _CardContainer(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 🦋 Animated mascot
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                        child: AnimatedBuilder(
                          animation: _eliScale,
                          builder: (context, child) {
                            return AnimatedScale(
                              scale: _eliScale.value,
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeInOut,
                              child: child,
                            );
                          },
                          child: Image.asset(
                            'assets/eli-with-book.png',
                            width: 120,
                            height: 120,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Text(
                        'Welcome Back!',
                        style: GoogleFonts.nunito(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: primarySkyBlue,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Let’s continue your adventure!",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.nunito(
                          fontSize: 16,
                          color: textNavy.withOpacity(0.7),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // 📧 Email field
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Email',
                          style: GoogleFonts.nunito(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: textNavy,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      _IconTextField(
                        controller: _emailController,
                        hintText: 'you@adventure.com',
                        icon: Icons.email_rounded,
                        keyboardType: TextInputType.emailAddress,
                        onTap: _validateEmailOnFocus,
                      ),
                      const SizedBox(height: 16),

                      // 🔒 Password field
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Password',
                          style: GoogleFonts.nunito(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: textNavy,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      _IconTextField(
                        controller: _passwordController,
                        hintText: '••••••••',
                        icon: Icons.lock_rounded,
                        obscureText: !_showPassword,
                        trailing: IconButton(
                          onPressed: () =>
                              setState(() => _showPassword = !_showPassword),
                          icon: Icon(
                            _showPassword
                                ? Icons.visibility_off_rounded
                                : Icons.visibility_rounded,
                            color: primarySkyBlue,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // 🎯 Sign In button
                      Listener(
                        onPointerDown: (_) =>
                            setState(() => _isPressingButton = true),
                        onPointerUp: (_) =>
                            setState(() => _isPressingButton = false),
                        onPointerCancel: (_) =>
                            setState(() => _isPressingButton = false),
                        child: AnimatedScale(
                          scale: _isPressingButton ? 0.98 : 1.0,
                          duration: const Duration(milliseconds: 120),
                          curve: Curves.easeOut,
                          child: SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: accentWarmOrange,
                                foregroundColor: Colors.white,
                                elevation: 6,
                                shadowColor: Colors.black.withOpacity(0.2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28),
                                ),
                                textStyle: GoogleFonts.nunito(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              onPressed: _onSubmit,
                              child: const Text("Let's Go!"),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 🧭 Sign-up link
                      Wrap(
                        alignment: WrapAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: GoogleFonts.nunito(
                              fontSize: 14,
                              color: textNavy.withOpacity(0.75),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignUpScreen(),
                              ),
                            ),
                            style: TextButton.styleFrom(
                              foregroundColor: accentWarmOrange,
                              textStyle: GoogleFonts.nunito(
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            child: const Text('Sign Up'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// 🎨 Reusable widgets
class _CardContainer extends StatelessWidget {
  final Widget child;

  const _CardContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _IconTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _IconTextField({
    required this.controller,
    required this.hintText,
    required this.icon,
    this.obscureText = false,
    this.keyboardType,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 2),
      ),
      child: Row(
        children: [
          const SizedBox(width: 14),
          Icon(icon, color: const Color(0xFF4FC3F7)),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: obscureText,
              keyboardType: keyboardType,
              textInputAction: TextInputAction.next,
              onTap: onTap,
              decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
                isDense: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 4, vertical: 18),
              ),
              style: GoogleFonts.nunito(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1F2937),
              ),
            ),
          ),
          if (trailing != null) trailing!,
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}
