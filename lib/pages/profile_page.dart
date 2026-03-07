import 'package:flutter/material.dart';
import '../widgets/main_layout.dart';

/// Profile page showing user name and email.
/// Ready for future backend integration.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  // TODO: Replace with Provider/backend when integrating auth
  static const String _placeholderName = 'User Name';
  static const String _placeholderEmail = 'user@example.com';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MainLayout(
      selectedRoute: '/profile',
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              Center(
                child: CircleAvatar(
                  radius: 48,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: Icon(
                    Icons.person,
                    size: 56,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                _placeholderName,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _placeholderEmail,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
