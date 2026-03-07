import 'package:flutter/material.dart';
import 'eli_app_bar.dart';
import 'app_drawer.dart';

/// Main layout wrapper with EliAppBar and AppDrawer.
/// Use for all screens that share the same navigation (Home, Profile, etc.).
class MainLayout extends StatefulWidget {
  const MainLayout({
    super.key,
    required this.child,
    required this.selectedRoute,
  });

  final Widget child;
  final String? selectedRoute;

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: EliAppBar(
        onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      drawer: AppDrawer(selectedRoute: widget.selectedRoute),
      body: widget.child,
    );
  }
}
