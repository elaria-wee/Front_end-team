import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'signin_screen.dart';

/// Sign Up screen for "Eli’s English Adventures"
/// - Modern Material 3 styling with rounded shapes and soft shadows
/// - Centered, scrollable layout for responsiveness
/// - Input validation and navigation per requirements
class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color accentColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          // Sky-blue to white gradient background
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
                child: _SignUpFormCard(accentColor: accentColor),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Internal stateful form to manage controllers and validation
class _SignUpFormCard extends StatefulWidget {
  final Color accentColor;
  const _SignUpFormCard({required this.accentColor});

  @override
  State<_SignUpFormCard> createState() => _SignUpFormCardState();
}

class _SignUpFormCardState extends State<_SignUpFormCard>
    with SingleTickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPressing = false;
  late final AnimationController _logoPulseController;
  late final Animation<double> _logoScale;

  @override
  void initState() {
    super.initState();
    _logoPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
    _logoScale = Tween<double>(begin: 0.98, end: 1.02)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(_logoPulseController);
  }

  @override
  void dispose() {
    _logoPulseController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Shows a SnackBar with color according to success or error
  void _showSnack(BuildContext context, String message, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.nunito(fontWeight: FontWeight.w800)),
        backgroundColor: success ? Colors.green.shade600 : Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  bool _isValidName(String name) {
    final nameRegex = RegExp(r'^[a-zA-Z\s]+$');
    return nameRegex.hasMatch(name);
  }

  bool _isValidPassword(String password) {
    if (password.length < 4) return false;
    final digitRegex = RegExp(r'[0-9]');
    return digitRegex.hasMatch(password);
  }

  void _validateEmailOnFocus() {
    final email = _emailController.text.trim();
    if (email.isNotEmpty && !_isValidEmail(email)) {
      _showSnack(context, 'Please enter a valid email address!');
    }
  }

  void _onSubmit(BuildContext context) {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      _showSnack(context, 'Please fill in all fields!');
      return;
    }

    if (!_isValidName(name)) {
      _showSnack(context, 'Name must contain only letters and spaces!');
      return;
    }

    if (!_isValidEmail(email)) {
      _showSnack(context, 'Please enter a valid email address!');
      return;
    }

    if (!_isValidPassword(password)) {
      _showSnack(context, 'Password must be at least 4 characters and include at least 1 digit!');
      return;
    }

    _showSnack(context, 'Account created successfully!', success: true);
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    final Color cardColor = Theme.of(context).colorScheme.surface;
    final Color primaryText = Theme.of(context).colorScheme.onSurface;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Top logo (try preferred path, then fallback)
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: AnimatedBuilder(
              animation: _logoScale,
              builder: (context, child) {
                return AnimatedScale(
                  scale: _logoScale.value,
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  child: child,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.asset(
                  'assets/eli-abc-blocks.png',
                  width: 110,
                  height: 110,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      // Project-preferred fallback
                      'assets/eli-abc-blocks.png',
                      width: 110,
                      height: 110,
                      fit: BoxFit.contain,
                    );
                  },
                ),
              ),
            ),
          ),

          const SizedBox(height: 6),

          // Title & Subtitle
          Text(
            'Join the Adventure!',
            textAlign: TextAlign.center,
            style: GoogleFonts.nunito(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: widget.accentColor,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Create your account to start learning',
            textAlign: TextAlign.center,
            style: GoogleFonts.nunito(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: primaryText.withOpacity(0.75),
            ),
          ),

          const SizedBox(height: 20),

          // Name Field
          _LabeledField(
            label: 'Name',
            child: _IconInput(
              controller: _nameController,
              hintText: 'Your name',
              icon: Icons.person,
              textInputAction: TextInputAction.next,
            ),
          ),

          const SizedBox(height: 14),

          // Email Field
          _LabeledField(
            label: 'Email',
            child: _IconInput(
              controller: _emailController,
              hintText: 'you@adventure.com',
              icon: Icons.email,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              onTap: _validateEmailOnFocus,
            ),
          ),

          const SizedBox(height: 14),

          // Password Field
          _LabeledField(
            label: 'Password',
            child: _IconInput(
              controller: _passwordController,
              hintText: '••••••••',
              icon: Icons.lock,
              obscureText: true,
              textInputAction: TextInputAction.done,
            ),
          ),

          const SizedBox(height: 24),

          // Start Learning button with modern rounded styling and elevation
          Listener(
            onPointerDown: (_) => setState(() => _isPressing = true),
            onPointerUp: (_) => setState(() => _isPressing = false),
            onPointerCancel: (_) => setState(() => _isPressing = false),
            child: AnimatedScale(
              scale: _isPressing ? 0.98 : 1.0,
              duration: const Duration(milliseconds: 120),
              curve: Curves.easeOut,
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => _onSubmit(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    elevation: 8,
                    shadowColor: Colors.black.withOpacity(0.2),
                    backgroundColor: widget.accentColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    textStyle: GoogleFonts.nunito(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  child: const Text('Start Learning!'),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Already have an account row
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 6,
            children: [
              Text(
                'Already have an account?',
                style: GoogleFonts.nunito(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: primaryText.withOpacity(0.8),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const SignInScreen()),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: widget.accentColor,
                  textStyle: GoogleFonts.nunito(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                child: const Text('Sign In'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Label above a form field
class _LabeledField extends StatelessWidget {
  final String label;
  final Widget child;
  const _LabeledField({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    final Color text = Theme.of(context).colorScheme.onSurface;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: text,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

/// Rounded input with leading icon and modern outline
class _IconInput extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final VoidCallback? onTap;

  const _IconInput({
    required this.controller,
    required this.hintText,
    required this.icon,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color border = Theme.of(context).dividerColor;
    final Color primary = Theme.of(context).colorScheme.primary;
    final Color fill = Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.35);

    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onTap: onTap,
      style: GoogleFonts.nunito(fontWeight: FontWeight.w800),
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon, color: primary),
        filled: true,
        fillColor: fill,
        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: border, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: primary, width: 2.5),
        ),
      ),
    );
  }
}


