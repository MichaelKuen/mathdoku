// Copyright © App Verse Games. All rights reserved.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'features/home/presentation/pages/home_page.dart';

void main() {
  runApp(const ProviderScope(child: MathdokuApp()));
}

class MathdokuApp extends StatelessWidget {
  const MathdokuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mathdoku',
      theme: kidsTheme,
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
