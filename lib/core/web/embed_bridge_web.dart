// Copyright © App Verse Games. All rights reserved.
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

void postParentResizeMessage(double height) {
  html.window.parent?.postMessage(
    {'type': 'appverse-embed-resize', 'height': height},
    '*',
  );
}
