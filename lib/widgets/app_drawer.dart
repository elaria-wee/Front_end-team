import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Drawer item for navigation.
class DrawerNavItem {
  const DrawerNavItem({
    required this.route,
    required this.label,
    required this.icon,
  });

  final String route;
  final String label;
  final IconData icon;
}

/// Duolingo-style sidebar drawer for kids learning app.
/// Gradient background, rounded corners, cute menu items.
class AppDrawer extends StatelessWidget {
  const AppDrawer({
    super.key,
    this.selectedRoute,
  });

  final String? selectedRoute;

  static const List<DrawerNavItem> _items = [
    DrawerNavItem(route: '/home', label: 'Home', icon: Icons.home_rounded),
    DrawerNavItem(route: '/profile', label: 'Profile', icon: Icons.person),
    DrawerNavItem(
      route: '/ai-story',
      label: 'AI Generate Story',
      icon: Icons.auto_awesome,
    ),
    DrawerNavItem(
      route: '/weekly-score',
      label: 'Weekly Score',
      icon: Icons.emoji_events,
    ),
  ];

  void _onItemTap(BuildContext context, DrawerNavItem item) {
    Navigator.pop(context);
    if (item.route == '/home') {
      Navigator.pushNamedAndRemoveUntil(context, item.route, (_) => false);
    } else {
      Navigator.pushNamed(context, item.route);
    }
  }

  @override
  Widget build(BuildContext context) {
    const radius = 24.0;

    return Drawer(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(radius)),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.gradientLight, AppColors.gradientSoft],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(4, 0),
            ),
          ],
        ),
        child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(context),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    children: _items.map((item) => _buildMenuItem(context, item)).toList(),
                  ),
                ),
                _buildFooter(context),
              ],
            ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.white,
            child: ClipOval(
              child: Image.asset(
                'assets/eli_elephant.png',
                width: 48,
                height: 48,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Text('🐘', style: TextStyle(fontSize: 24)),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Eli's English Adventures",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkBlue,
                        fontSize: 18,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Learn English with Eli! 🐘',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.darkBlue.withValues(alpha: 0.8),
                        fontSize: 13,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, DrawerNavItem item) {
    final isActive = selectedRoute == item.route;

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _onItemTap(context, item),
          borderRadius: BorderRadius.circular(16),
          splashColor: AppColors.gradientLight.withValues(alpha: 0.6),
          highlightColor: AppColors.gradientLight.withValues(alpha: 0.4),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: isActive ? AppColors.primaryBlue : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: AppColors.primaryBlue.withValues(alpha: 0.35),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              children: [
                Icon(
                  item.icon,
                  size: 24,
                  color: isActive ? Colors.white : AppColors.darkBlue,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item.label,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                          color: isActive ? Colors.white : AppColors.darkBlue,
                          fontSize: 15,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: Text(
        '🎉 Keep Learning!',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.darkBlue.withValues(alpha: 0.7),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
