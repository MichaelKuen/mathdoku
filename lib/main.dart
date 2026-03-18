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
      title: 'Sudoku Pro',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      
      // LIGHT THEME
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2196F3),
          surface: const Color(0xFFF8FAFC),
        ),
        textTheme: GoogleFonts.robotoMonoTextTheme(),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: Color(0xFFF8FAFC),
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),

      // DARK THEME
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2196F3),
          brightness: Brightness.dark,
          surface: const Color(0xFF0F172A),
        ),
        textTheme: GoogleFonts.robotoMonoTextTheme(ThemeData.dark().textTheme),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: Color(0xFF0F172A),
          elevation: 0,
        ),
      ),
      home: const HomePage(),
    );
  }
}
