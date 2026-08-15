// Copyright © App Verse Games. All rights reserved.
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const kPrimary    = Color(0xFFFF6B6B);
const kSecondary  = Color(0xFF4ECDC4);
const kBackground = Color(0xFFFFF9F0);
const kSurface    = Color(0xFFFFFFFF);

final ThemeData kidsTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: kPrimary,
    secondary: kSecondary,
    surface: kSurface,
    brightness: Brightness.light,
  ).copyWith(surface: kBackground),
  scaffoldBackgroundColor: kBackground,
  textTheme: GoogleFonts.nunitoTextTheme(),
  appBarTheme: AppBarTheme(
    backgroundColor: kPrimary,
    foregroundColor: Colors.white,
    elevation: 0,
    titleTextStyle: GoogleFonts.nunito(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
  ),
);
