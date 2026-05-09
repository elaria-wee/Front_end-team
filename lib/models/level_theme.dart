import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';

// Constants
const int COMPLETED = 5;
const int TOTAL = 20;

// LevelTheme Model
class LevelTheme {
  final String name;
  final String emoji;
  final Color bgColor;
  final Color accentColor;
  final Color accentColorDark;
  final List<Color> iconBubbleGradient;
  final List<Color> progressGradient;
  final List<Color> listeningGradient;
  final Color playIconColor;
  final Color completedRingColor;
  final Color completedBadgeColor;
  final List<Color> currentGradient;
  final Color currentRingColor;
  final Color lockedBgColor;
  final Color lockedBadgeBgColor;
  final Color lockedBadgeTextColor;
  final Color lockedTextColor;
  final Color pillTextColor;
  final Color starColor;
  final List<String> storyEmojis;
  final List<Sticker> stickers;
  final String encouragement;

  LevelTheme({
    required this.name,
    required this.emoji,
    required this.bgColor,
    required this.accentColor,
    required this.accentColorDark,
    required this.iconBubbleGradient,
    required this.progressGradient,
    required this.listeningGradient,
    required this.playIconColor,
    required this.completedRingColor,
    required this.completedBadgeColor,
    required this.currentGradient,
    required this.currentRingColor,
    required this.lockedBgColor,
    required this.lockedBadgeBgColor,
    required this.lockedBadgeTextColor,
    required this.lockedTextColor,
    required this.pillTextColor,
    required this.starColor,
    required this.storyEmojis,
    required this.stickers,
    required this.encouragement,
  });
}

// Sticker Model
class Sticker {
  final String emoji;
  final double top;
  final double? left;
  final double? right;
  final String animation; // 'float' or 'sticker'

  Sticker({
    required this.emoji,
    required this.top,
    this.left,
    this.right,
    this.animation = 'sticker',
  });
}

// StoryState Enum
enum StoryState { completed, current, locked }

// Theme Map
final Map<String, LevelTheme> themes = {
  '1': LevelTheme(
    name: 'Beginner',
    emoji: '🎓',
    bgColor: const Color(0xFFE0F4FF), // baby-blue
    accentColor: const Color(0xFF0EA5E9), // sky-500
    accentColorDark: const Color(0xFF0369A1), // sky-700
    iconBubbleGradient: [
      const Color(0xFF60D5FF), // sky-400
      const Color(0xFF0EA5E9), // sky-500
    ],
    progressGradient: [
      const Color(0xFF60D5FF), // sky-400
      const Color(0xFF10B981), // emerald-400
    ],
    listeningGradient: [
      const Color(0xFF60D5FF), // sky-400
      const Color(0xFF0EA5E9), // sky-500
      const Color(0xFF0284C7), // sky-600
    ],
    playIconColor: const Color(0xFF0EA5E9),
    completedRingColor: const Color(0xFFA7F3D0), // emerald-300
    completedBadgeColor: const Color(0xFF10B981), // emerald-500
    currentGradient: [
      const Color(0xFFFCD34D), // amber-300
      const Color(0xFFFB923C), // orange-400
    ],
    currentRingColor: const Color(0xFFFEE2A3), // amber-200
    lockedBgColor: const Color(0xFFF0F9FF), // sky-50
    lockedBadgeBgColor: const Color(0xFFBAE6FD), // sky-200
    lockedBadgeTextColor: const Color(0xFF0EA5E9), // sky-500
    lockedTextColor: const Color(0xFF7DD3FC), // sky-400
    pillTextColor: const Color(0xFF0369A1), // sky-700
    starColor: const Color(0xFFFBBF24), // amber-400
    storyEmojis: [
      '🌻',
      '🦋',
      '🐰',
      '🌈',
      '🐢',
      '🍎',
      '🚀',
      '🐳',
      '🎈',
      '🐝',
      '🌙',
      '🦁',
      '🍩',
      '🐧',
      '🌳',
      '🐠',
      '🎨',
      '🦉',
      '🍓',
      '🎁',
    ],
    stickers: [Sticker(emoji: '⭐', top: 176, right: 4)],
    encouragement: 'Keep going, superstar! 💙',
  ),
  '2': LevelTheme(
    name: 'Explorer',
    emoji: '🚀',
    bgColor: const Color(0xFFFFF7ED), // warm cream / light peach
    accentColor: const Color(0xFFF97316), // orange
    accentColorDark: const Color(0xFFEA580C), // deep orange
    iconBubbleGradient: [
      const Color(0xFFF97316), // orange
      const Color(0xFFF59E0B), // amber
    ],
    progressGradient: [
      const Color(0xFFF97316), // orange
      const Color(0xFFF59E0B), // amber
    ],
    listeningGradient: [
      const Color(0xFFF59E0B), // amber
      const Color(0xFFF97316), // orange
      const Color(0xFFF43F5E), // rose
    ],
    playIconColor: const Color(0xFFF97316), // orange
    completedRingColor: const Color(0xFFFCD34D), // light amber
    completedBadgeColor: const Color(0xFFF59E0B), // amber
    currentGradient: [
      const Color(0xFFF59E0B), // amber
      const Color(0xFFF97316), // orange
    ],
    currentRingColor: const Color(0xFFFED7AA), // soft orange
    lockedBgColor: const Color(0xFFFFF7ED), // light peach
    lockedBadgeBgColor: const Color(0xFFFED7AA), // peach orange
    lockedBadgeTextColor: const Color(0xFFF97316), // orange
    lockedTextColor: const Color(
      0xFFF97316,
    ).withValues(alpha: 0.7), // soft orange
    pillTextColor: const Color(0xFFEA580C), // deep orange
    starColor: const Color(0xFFF59E0B), // amber yellow
    storyEmojis: [
      '🦊',
      '🍊',
      '🌅',
      '⭐',
      '🔥',
      '🍯',
      '🦁',
      '🌻',
      '🥕',
      '🎃',
      '🏵️',
      '🦒',
      '🍑',
      '🐯',
      '🌞',
      '🦘',
      '🍩',
      '🎪',
      '🪁',
      '🏆',
    ],
    stickers: [
      Sticker(emoji: '🌞', top: 160, left: 8, animation: 'float'),
      Sticker(emoji: '✨', top: 224, right: 8, animation: 'float'),
      Sticker(emoji: '🍊', top: 288, left: 16, animation: 'float'),
    ],
    encouragement: 'Sunny job, explorer! 🧡',
  ),
  '3': LevelTheme(
    name: 'Champion',
    emoji: '🏆',
    bgColor: const Color(0xFFD1FAE5), // mint-green
    accentColor: const Color(0xFF10B981), // emerald-500
    accentColorDark: const Color(0xFF047857), // emerald-700
    iconBubbleGradient: [
      const Color(0xFF6EE7B7), // emerald-400
      const Color(0xFF14B8A6), // teal-500
    ],
    progressGradient: [
      const Color(0xFF6EE7B7), // emerald-400
      const Color(0xFFFCD34D), // amber-400
    ],
    listeningGradient: [
      const Color(0xFF6EE7B7), // emerald-400
      const Color(0xFF14B8A6), // teal-500
      const Color(0xFF06B6D4), // cyan-500
    ],
    playIconColor: const Color(0xFF10B981),
    completedRingColor: const Color(0xFFFCD34D), // amber-300
    completedBadgeColor: const Color(0xFFF59E0B), // amber-500
    currentGradient: [
      const Color(0xFFBEF264), // lime-300
      const Color(0xFF6EE7B7), // emerald-400
    ],
    currentRingColor: const Color(0xFFA7F3D0), // emerald-200
    lockedBgColor: const Color(0xFFF0FDF4), // emerald-50
    lockedBadgeBgColor: const Color(0xFFA7F3D0), // emerald-200
    lockedBadgeTextColor: const Color(0xFF10B981), // emerald-500
    lockedTextColor: const Color(0xFF6EE7B7), // emerald-400
    pillTextColor: const Color(0xFF047857), // emerald-700
    starColor: const Color(0xFFFCD34D), // amber-400
    storyEmojis: [
      '🦖',
      '🌵',
      '⚡',
      '🔥',
      '🐉',
      '🗺️',
      '⛰️',
      '🏰',
      '🛡️',
      '⚔️',
      '🦅',
      '🌋',
      '💫',
      '🐲',
      '🪨',
      '🏹',
      '👑',
      '🧭',
      '🪶',
      '🥇',
    ],
    stickers: [Sticker(emoji: '🌟', top: 176, right: 4, animation: 'sticker')],
    encouragement: "You're a true champion! 💚",
  ),
};
