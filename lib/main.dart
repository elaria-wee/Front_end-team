import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/welcome_screen.dart';
import 'screens/signin_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/navepar_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/ai_story_screen.dart';
import 'pages/weekly_score_page.dart';
import 'screens/reading_screen.dart';
import 'theme/app_colors.dart';
import 'providers/theme_provider.dart';
import 'providers/ai_story_provider.dart';
import 'providers/weekly_score_provider.dart';

void main() {
  runApp(const EliEnglishAdventuresApp());
}

/// Main app widget for Eli's English Adventures
class EliEnglishAdventuresApp extends StatelessWidget {
  const EliEnglishAdventuresApp({super.key});

  ThemeData _buildLightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.skyBlue,
        brightness: Brightness.light,
      ),
      primaryColor: AppColors.skyBlue,
      scaffoldBackgroundColor: AppColors.background,
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
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.skyBlue,
        brightness: Brightness.dark,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(elevation: 8),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(elevation: 6),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AiStoryProvider()),
        ChangeNotifierProvider(create: (_) => WeeklyScoreProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'Eli\'s English Adventures',
            debugShowCheckedModeBanner: false,
            theme: _buildLightTheme(),
            darkTheme: _buildDarkTheme(),
            themeMode: themeProvider.themeMode,
            initialRoute: '/',
            routes: {
              '/': (context) => const WelcomeScreen(),
              '/signin': (context) => const SignInScreen(),
              '/signup': (context) => const SignUpScreen(),
              '/home': (context) => const HomeScreen(),
              '/navpar': (context) => const NaveParScreen(),
              '/profile': (context) => const ProfileScreen(),
              '/ai-story': (context) => const AIStoryScreen(),
              '/weekly-score': (context) => const WeeklyScorePage(),
              '/reading': (context) => const ReadingScreen(),
            },
          );
        },
      ),
    );
  }
}
