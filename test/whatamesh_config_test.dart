import 'package:app/src/whatamesh/model/whatamesh_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('wave layer defaults match js loop', () {
    const config = WhatameshConfig();
    final layers = config.buildWaveLayers(const [
      Color(0xFF111111),
      Color(0xFF222222),
      Color(0xFF333333),
      Color(0xFF444444),
    ]);

    expect(layers.length, 3);
    expect(layers.first.noiseFreqX, closeTo(2.25, 0.000001));
    expect(layers.first.noiseFreqY, closeTo(3.25, 0.000001));
    expect(layers.first.noiseSpeed, closeTo(11.3, 0.000001));
    expect(layers.first.noiseFlow, closeTo(6.8, 0.000001));
    expect(layers.first.noiseSeed, closeTo(15, 0.000001));
    expect(layers.last.noiseCeil, closeTo(0.84, 0.000001));
  });
}
