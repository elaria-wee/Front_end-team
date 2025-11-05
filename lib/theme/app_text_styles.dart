import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Text styles for Eli's English Adventures
/// Using Nunito font family for playful, rounded appearance
class AppTextStyles {
  // Font Family
  static String get fontFamily => GoogleFonts.nunito().fontFamily!;

  // Title Styles
  static TextStyle get welcomeTitle => GoogleFonts.nunito(
    fontSize: 40,
    fontWeight: FontWeight.w900, // ExtraBold/Black
    color: AppColors.skyBlue,
    letterSpacing: 1.0,
    shadows: [
      Shadow(
        color: AppColors.textShadow,
        offset: const Offset(2, 2),
        blurRadius: 4,
      ),
    ],
  );

  static TextStyle get welcomeSubtitle => GoogleFonts.nunito(
    fontSize: 36,
    fontWeight: FontWeight.w900, // ExtraBold/Black
    color: AppColors.skyBlue,
    letterSpacing: 1.2,
    shadows: [
      Shadow(
        color: AppColors.textShadow,
        offset: const Offset(2, 2),
        blurRadius: 4,
      ),
    ],
  );

  // Button Styles
  static TextStyle get signInButton => GoogleFonts.nunito(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.textOnOrange,
    letterSpacing: 0.5,
  );

  static TextStyle get signUpButton => GoogleFonts.nunito(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.textOnBlue,
    letterSpacing: 0.5,
  );

  // Body Text Styles
  static TextStyle get bodyLarge => GoogleFonts.nunito(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    letterSpacing: 0.3,
  );

  static TextStyle get bodyMedium => GoogleFonts.nunito(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    letterSpacing: 0.2,
  );
}
