import 'package:flutter/material.dart';
import '../widgets/navbar.dart';

/// Main screen with responsive Navbar (Drawer or BottomNavigationBar).
/// Contains Profile, AI Generate Story, and Weekly Score sections.
class NaveParScreen extends StatelessWidget {
  const NaveParScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const NavBarShell();
  }
}
