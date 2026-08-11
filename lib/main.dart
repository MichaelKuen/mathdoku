// Copyright © FullStackShack. All rights reserved.
// Unauthorised use, reproduction, or distribution is strictly prohibited.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'core/providers/theme_provider.dart';

void main() {
  runApp(
    const ProviderScope(
      child: SudokuApp(),
    ),
  );
}

class SudokuApp extends ConsumerWidget {
  const SudokuApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeNotifierProvider);

    return MaterialApp(
      title: 'Sudoku',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.light(
          primary: Color(0xFFD32F2F),
          onPrimary: Color(0xFFFFFFFF),
          secondary: Color(0xFF1565C0),
          onSecondary: Color(0xFFFFFFFF),
          surface: Color(0xFFF5F5F5),
          onSurface: Color(0xFF1A1A1A),
          outline: Color(0xFFBDBDBD),
          inversePrimary: Color(0xFFEEEEEE),
        ),
        textTheme: GoogleFonts.robotoMonoTextTheme(),
        appBarTheme: const AppBarTheme(centerTitle: false, elevation: 0),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFF5252),
          onPrimary: Color(0xFFFFFFFF),
          secondary: Color(0xFF40C4FF),
          onSecondary: Color(0xFF002233),
          surface: Color(0xFF1A1A2E),
          onSurface: Color(0xFFE0E0E0),
          outline: Color(0xFF5A5A7A),
          inversePrimary: Color(0xFF2A2A4A),
        ),
        textTheme: GoogleFonts.robotoMonoTextTheme(ThemeData.dark().textTheme),
        appBarTheme: const AppBarTheme(centerTitle: false, elevation: 0),
      ),
      home: const HomePage(),
    );
  }
}
