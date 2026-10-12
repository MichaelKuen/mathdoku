// Copyright © App Verse Games. All rights reserved.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/web_mode_provider.dart';

/// Shows [emoji] on mobile and [icon] on web. Flutter web downloads an emoji
/// font from Google for any emoji or symbol the bundled fonts lack, so the web
/// build uses Material icons instead.
class Glyph extends ConsumerWidget {
  final String emoji;
  final IconData icon;
  final double size;
  final Color? color;

  const Glyph(this.emoji, this.icon, {super.key, this.size = 18, this.color});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (ref.watch(webModeProvider)) {
      return Icon(icon, size: size, color: color);
    }
    return Text(emoji, style: TextStyle(fontSize: size, color: color));
  }
}
