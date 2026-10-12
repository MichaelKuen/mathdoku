// Copyright © App Verse Games. All rights reserved.
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// True for the web build, which is embedded in an iframe on
/// appversegames.com: the page around it already shows the title, rules and
/// links, so the app shows only the game. Tests override this to check the
/// web layout on the VM.
final webModeProvider = Provider<bool>((ref) => kIsWeb);
