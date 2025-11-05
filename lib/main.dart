import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'screens/signin_screen.dart';
import 'theme/app_colors.dart';

void main() {
  runApp(const EliEnglishAdventuresApp());
}

/// Main app widget for Eli's English Adventures
class EliEnglishAdventuresApp extends StatelessWidget {
  const EliEnglishAdventuresApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eli\'s English Adventures',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: AppColors.skyBlue,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.skyBlue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 8,
            shadowColor: AppColors.shadowMedium,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            elevation: 6,
            shadowColor: AppColors.shadowLight,
          ),
        ),
      ),
      home: const WelcomeScreen(),
      routes: {
        '/signin': (context) => const PlaceholderScreen(title: 'Sign In'),
        '/signup': (context) => const PlaceholderScreen(title: 'Sign Up'),
      },
    );
  }
}

/// Placeholder screen for Sign In and Sign Up
class PlaceholderScreen extends StatelessWidget {
  final String title;

  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: AppColors.skyBlue,
        foregroundColor: AppColors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              title == 'Sign In' ? Icons.login : Icons.person_add,
              size: 100,
              color: AppColors.skyBlue,
            ),
            const SizedBox(height: 20),
            Text(
              '$title Screen',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'This screen will be implemented next!',
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.warmOrange,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}
