// Copyright © App Verse Games. All rights reserved.
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/providers/web_mode_provider.dart';
import 'features/game/domain/models/game_state.dart';
import 'features/game/presentation/pages/game_page.dart';
import 'features/home/presentation/pages/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('assets/fonts/nunito/OFL.txt');
    yield LicenseEntryWithLineBreaks(['Nunito'], license);
  });
  runApp(const ProviderScope(child: MathdokuApp()));
}

class MathdokuApp extends ConsumerWidget {
  const MathdokuApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isWeb = ref.watch(webModeProvider);
    return MaterialApp(
      title: 'Mathdoku',
      theme: kidsTheme,
      debugShowCheckedModeBanner: false,
      // Web opens straight into a game; levels are in the New game dialog.
      home:
          isWeb ? const GamePage(autoStart: Difficulty.easy) : const HomePage(),
    );
  }
}
