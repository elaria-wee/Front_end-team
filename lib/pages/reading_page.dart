import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class ReadingPage extends StatelessWidget {
  const ReadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gradientSoft.withValues(alpha: 0.65),
      appBar: AppBar(
        backgroundColor: Colors.white.withValues(alpha: 0.9),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Reading'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'ReadingPage() placeholder',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColors.darkBlue,
              ),
        ),
      ),
    );
  }
}

