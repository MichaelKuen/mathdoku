// Copyright © App Verse Games. All rights reserved.
import 'package:flutter/material.dart';

const kPrimary = Color(0xFFFF6B6B);
const kSecondary = Color(0xFF4ECDC4);
const kBackground = Color(0xFFFFF9F0);
const kSurface = Color(0xFFFFFFFF);

// appversegames.com site colours, used by the web build only.
const kSiteIvory = Color(0xFFF6F3EC);
const kSiteNavy = Color(0xFF16193A);
const kSiteAmber = Color(0xFFF2A541);
const kSiteTeal = Color(0xFF0B6B63);

/// Game colours that differ between the mobile app and the web build.
@immutable
class GameColors extends ThemeExtension<GameColors> {
  final Color frame; // board outline
  final Color selection; // selected cell
  final Color sameNumber; // cells holding the selected digit
  final Color statsBar; // background of the timer / mistakes bar
  final Color mistakes; // mistake count

  const GameColors({
    required this.frame,
    required this.selection,
    required this.sameNumber,
    required this.statsBar,
    required this.mistakes,
  });

  static const mobile = GameColors(
    frame: kPrimary,
    selection: kPrimary,
    sameNumber: kSecondary,
    statsBar: Color(0x14FF6B6B), // kPrimary at 8%
    mistakes: kPrimary,
  );

  static const web = GameColors(
    frame: kSiteNavy,
    selection: kSiteAmber,
    sameNumber: kSiteTeal,
    statsBar: Color(0x33F2A541), // amber at 20%
    mistakes: kSiteNavy,
  );

  static GameColors of(BuildContext context) =>
      Theme.of(context).extension<GameColors>() ?? mobile;

  @override
  GameColors copyWith({
    Color? frame,
    Color? selection,
    Color? sameNumber,
    Color? statsBar,
    Color? mistakes,
  }) =>
      GameColors(
        frame: frame ?? this.frame,
        selection: selection ?? this.selection,
        sameNumber: sameNumber ?? this.sameNumber,
        statsBar: statsBar ?? this.statsBar,
        mistakes: mistakes ?? this.mistakes,
      );

  @override
  GameColors lerp(GameColors? other, double t) {
    if (other == null) return this;
    return GameColors(
      frame: Color.lerp(frame, other.frame, t)!,
      selection: Color.lerp(selection, other.selection, t)!,
      sameNumber: Color.lerp(sameNumber, other.sameNumber, t)!,
      statsBar: Color.lerp(statsBar, other.statsBar, t)!,
      mistakes: Color.lerp(mistakes, other.mistakes, t)!,
    );
  }
}

/// Web theme in the site colours, so the iframe blends into the ivory page.
final ThemeData webTheme = ThemeData(
  useMaterial3: true,
  fontFamily: 'Nunito',
  colorScheme: ColorScheme.fromSeed(
    seedColor: kSiteNavy,
    brightness: Brightness.light,
  ).copyWith(
    primary: kSiteNavy,
    secondary: kSiteAmber,
    onSurface: kSiteNavy,
    surface: kSiteIvory,
  ),
  scaffoldBackgroundColor: kSiteIvory,
  dialogTheme: const DialogThemeData(backgroundColor: Colors.white),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(foregroundColor: kSiteTeal),
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
      foregroundColor: kSiteNavy,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
  ),
  extensions: const [GameColors.web],
);

final ThemeData kidsTheme = ThemeData(
  useMaterial3: true,
  extensions: const [GameColors.mobile],
  fontFamily: 'Nunito',
  colorScheme: ColorScheme.fromSeed(
    seedColor: kPrimary,
    secondary: kSecondary,
    surface: kSurface,
    brightness: Brightness.light,
  ).copyWith(surface: kBackground),
  scaffoldBackgroundColor: kBackground,
  appBarTheme: AppBarTheme(
    backgroundColor: kPrimary,
    foregroundColor: Colors.white,
    elevation: 0,
    titleTextStyle: const TextStyle(
      fontFamily: 'Nunito',
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
