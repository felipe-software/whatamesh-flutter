import 'package:app/main.dart';
import 'package:app/whatamesh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('app renders whatamesh demo controls', (tester) async {
    await tester.pumpWidget(const WhatameshApp());

    expect(find.text('whatamesh / flutter'), findsOneWidget);
    expect(find.text('Randomize'), findsOneWidget);
    expect(find.byType(Whatamesh), findsOneWidget);
  });

  testWidgets('whatamesh respects paused controller time', (tester) async {
    final controller = WhatameshController(
      colors: WhatameshPalette.presets.first,
      darkenTop: false,
      playing: false,
      config: const WhatameshConfig(),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: SizedBox.expand(
          child: Whatamesh(
            colors: controller.colors,
            playing: false,
            controller: controller,
          ),
        ),
      ),
    );

    final before = controller.time;
    await tester.pump(const Duration(milliseconds: 100));
    expect(controller.time, before);
  });
}
