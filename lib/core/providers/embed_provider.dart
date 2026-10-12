// Copyright © App Verse Games. All rights reserved.
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';

final isEmbeddedProvider = Provider<bool>((ref) {
  if (!kIsWeb) return false;
  return Uri.base.queryParameters['embed'] == '1';
});
