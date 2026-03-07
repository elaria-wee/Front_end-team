import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../pages/profile_page.dart';
import '../pages/ai_story_page.dart';
import '../pages/weekly_score_page.dart';

/// Screen breakpoint: Drawer for >= 600px, BottomNavBar for < 600px.
const double _navBreakpoint = 600;

/// Navigation destinations.
enum NavDestination {
  profile,
  aiStory,
  weeklyScore,
}

extension NavDestinationX on NavDestination {
  String get label {
    switch (this) {
      case NavDestination.profile:
        return 'Profile';
      case NavDestination.aiStory:
        return 'AI Generate Story';
      case NavDestination.weeklyScore:
        return 'Weekly Score';
    }
  }

  IconData get icon {
    switch (this) {
      case NavDestination.profile:
        return Icons.person;
      case NavDestination.aiStory:
        return Icons.auto_stories;
      case NavDestination.weeklyScore:
        return Icons.emoji_events;
    }
  }

  Widget get page {
    switch (this) {
      case NavDestination.profile:
        return const ProfilePage();
      case NavDestination.aiStory:
        return const AiStoryPage();
      case NavDestination.weeklyScore:
        return const WeeklyScorePage();
    }
  }
}

/// Responsive shell: Drawer on large screens, BottomNavigationBar on small.
class NavBarShell extends StatelessWidget {
  const NavBarShell({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final useDrawer = width >= _navBreakpoint;

    return NavBarShellContent(useDrawer: useDrawer);
  }
}

class NavBarShellContent extends StatefulWidget {
  const NavBarShellContent({super.key, required this.useDrawer});

  final bool useDrawer;

  @override
  State<NavBarShellContent> createState() => _NavBarShellState();
}

class _NavBarShellState extends State<NavBarShellContent> {
  late NavDestination _currentDestination;

  @override
  void initState() {
    super.initState();
    _currentDestination = NavDestination.profile;
  }

  void _selectDestination(NavDestination dest) {
    setState(() => _currentDestination = dest);
    if (widget.useDrawer) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final appBar = AppBar(
      title: Text(_currentDestination.label),
      actions: [
        IconButton(
          icon: Icon(
            theme.brightness == Brightness.dark ? Icons.light_mode : Icons.dark_mode,
          ),
          onPressed: () => context.read<ThemeProvider>().toggleTheme(),
        ),
      ],
    );

    final drawer = Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
            ),
            child: Text(
              'Eli\'s English Adventures',
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...NavDestination.values.map(
            (d) => ListTile(
              leading: Icon(d.icon),
              title: Text(d.label),
              selected: _currentDestination == d,
              onTap: () => _selectDestination(d),
            ),
          ),
        ],
      ),
    );

    final bottomNav = NavigationBar(
      selectedIndex: NavDestination.values.indexOf(_currentDestination),
      onDestinationSelected: (i) => _selectDestination(NavDestination.values[i]),
      destinations: NavDestination.values
          .map(
            (d) => NavigationDestination(
              icon: Icon(d.icon),
              label: d.label,
            ),
          )
          .toList(),
    );

    if (widget.useDrawer) {
      return Scaffold(
        appBar: appBar,
        drawer: drawer,
        body: _currentDestination.page,
      );
    }

    return Scaffold(
      appBar: appBar,
      body: _currentDestination.page,
      bottomNavigationBar: bottomNav,
    );
  }
}
