// ignore_for_file: avoid_print
import 'dart:io';
import 'package:image/image.dart' as img;

void main() {
  print('Generating Sudoku app icons...');

  for (final size in [192, 512]) {
    final bytes = img.encodePng(_buildIcon(size));
    File('web/icons/Icon-$size.png').writeAsBytesSync(bytes);
    File('web/icons/Icon-maskable-$size.png').writeAsBytesSync(bytes);
    print('  Icon-$size.png');
  }

  File('web/favicon.png').writeAsBytesSync(img.encodePng(_buildIcon(64)));
  print('  favicon.png');
  print('Done.');
}

img.Image _buildIcon(int size) {
  final image = img.Image(width: size, height: size);

  final bg   = img.ColorRgb8(26,  26,  46);   // #1A1A2E
  final red  = img.ColorRgb8(255, 82,  82);   // #FF5252
  final line = img.ColorRgb8(90,  90,  122);  // #5A5A7A

  img.fill(image, color: bg);

  final pad  = (size * 0.13).round();
  final area = size - pad * 2;
  final cell = area ~/ 3;

  // Fill X pattern (corners + centre) with red
  for (var r = 0; r < 3; r++) {
    for (var c = 0; c < 3; c++) {
      if (r == c || r + c == 2) {
        final inner = (cell * 0.10).round();
        img.fillRect(
          image,
          x1: pad + c * cell + inner,
          y1: pad + r * cell + inner,
          x2: pad + c * cell + cell - inner - 1,
          y2: pad + r * cell + cell - inner - 1,
          color: red,
        );
      }
    }
  }

  // Grid lines
  final lw = (size / 170).ceil().clamp(1, 4);
  for (var i = 0; i <= 3; i++) {
    final p = pad + i * cell;
    for (var t = 0; t < lw; t++) {
      img.drawLine(image, x1: pad,       y1: p + t,   x2: pad + area, y2: p + t,   color: line);
      img.drawLine(image, x1: p + t,     y1: pad,     x2: p + t,      y2: pad + area, color: line);
    }
  }

  return image;
}
