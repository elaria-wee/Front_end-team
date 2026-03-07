import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Duolingo-style AppBar for kids learning app.
/// Blue background, white text, Eli avatar, menu icon on left.
class EliAppBar extends StatelessWidget implements PreferredSizeWidget {
  const EliAppBar({super.key, this.onMenuTap});

  /// Called when the menu icon is tapped. Opens the drawer.
  final VoidCallback? onMenuTap;

  @override
  Size get preferredSize => const Size.fromHeight(100);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isCompact = width < 400;
    final avatarSize = isCompact ? 40.0 : 48.0;
    final titleSize = isCompact ? 16.0 : (width < 600 ? 18.0 : 20.0);
    final subtitleSize = isCompact ? 11.0 : 13.0;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryBlue,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isCompact ? 12 : 20,
            vertical: isCompact ? 12 : 16,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                onPressed: onMenuTap ?? () {},
                icon: const Icon(Icons.menu_rounded),
                color: Colors.white,
                iconSize: isCompact ? 26 : 30,
                tooltip: 'Open menu',
                padding: const EdgeInsets.all(6),
                constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
              ),
              const SizedBox(width: 8),
              CircleAvatar(
                radius: avatarSize / 2,
                backgroundColor: Colors.white,
                child: ClipOval(
                  child: Image.asset(
                    'assets/eli_elephant.png',
                    width: avatarSize,
                    height: avatarSize,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Text(
                      '🐘',
                      style: TextStyle(fontSize: avatarSize * 0.5),
                    ),
                  ),
                ),
              ),
              SizedBox(width: isCompact ? 10 : 14),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Eli's English Adventures",
                      style: TextStyle(
                        fontSize: titleSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.3,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: isCompact ? 2 : 4),
                    Text(
                      'Learn English with Eli! 🐘',
                      style: TextStyle(
                        fontSize: subtitleSize,
                        color: Colors.white.withValues(alpha: 0.95),
                        fontWeight: FontWeight.w500,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
