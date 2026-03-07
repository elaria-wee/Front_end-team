import 'package:flutter/material.dart';

/// App color palette for Eli's English Adventures
/// Following child-friendly design guidelines with soft, cheerful colors
class AppColors {
  // Primary Colors
  static const Color primaryBlue = Color(0xFF4F9DFF);
  static const Color skyBlue = Color(0xFF87CEEB); // Sky Blue
  static const Color gradientLight = Color(0xFFAEE6FF);
  static const Color gradientSoft = Color(0xFFE6F0FF);
  static const Color darkBlue = Color(0xFF1E3A5F);
  static const Color warmOrange = Color(0xFFFFA500); // Warm Orange
  static const Color white = Color(0xFFFFFFFF); // White

  // Background Colors
  static const Color background = white;
  static const Color overlayBlue = Color(
    0x1A87CEEB,
  ); // Sky Blue with 10% opacity

  // Text Colors
  static const Color textPrimary = Color(0xFF2C3E50); // Dark Blue Gray
  static const Color textSecondary = Color(0xFF7F8C8D); // Gray
  static const Color textOnOrange = white; // White text on orange
  static const Color textOnBlue = skyBlue; // Sky blue text

  // Button Colors
  static const Color signInButton = warmOrange;
  static const Color signUpButtonBorder = skyBlue;
  static const Color signUpButtonBackground = Color(
    0xE6FFFFFF,
  ); // White with 90% opacity

  // Shadow Colors
  static const Color shadowLight = Color(0x1A000000); // 10% opacity black
  static const Color shadowMedium = Color(0x33000000); // 20% opacity black
  static const Color textShadow = Color(
    0x40000000,
  ); // 25% opacity black for text

  // Animation Colors
  static const Color bounceHighlight = Color(
    0x1AFFFFFF,
  ); // White highlight for animations
}
