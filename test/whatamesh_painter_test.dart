import 'dart:ui';

import 'package:app/src/whatamesh/model/whatamesh_config.dart';
import 'package:app/src/whatamesh/whatamesh_controller.dart';
import 'package:app/src/whatamesh/whatamesh_painter.dart';
import 'package:app/src/whatamesh/whatamesh_palette.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('painter snapshot generates visible non-black colors', () {
    final controller = WhatameshController(
      colors: WhatameshPalette.presets.first,
      darkenTop: false,
      playing: false,
      config: const WhatameshConfig(),
    )..setTime(1253106);

    final painter = WhatameshPainter(
      controller: controller,
      config: const WhatameshConfig(),
      density: const Offset(0.06, 0.16),
    );

    final snapshot = painter.debugSnapshotForSize(const Size(800, 500));

    expect(snapshot.colors, isNotEmpty);
    expect(
      snapshot.colors.any((color) {
        final argb = color.toUnsigned(32);
        final red = (argb >> 16) & 0xFF;
        final green = (argb >> 8) & 0xFF;
        final blue = argb & 0xFF;
        return red > 8 || green > 8 || blue > 8;
      }),
      isTrue,
    );
  });
}
