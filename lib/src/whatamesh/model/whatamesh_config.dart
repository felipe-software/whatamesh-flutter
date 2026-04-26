import 'package:flutter/material.dart';

import 'wave_layer_config.dart';

@immutable
class WhatameshConfig {
  const WhatameshConfig({
    this.density = const Offset(0.06, 0.16),
    this.initialTime = 1253106,
    this.shadowPower = 6,
    this.minShadowPowerWidth = 600,
    this.globalNoise = const GlobalNoiseConfig(),
    this.vertexDeform = const VertexDeformConfig(),
    this.activeColors = const [true, true, true, true],
  });

  final Offset density;
  final double initialTime;
  final double shadowPower;
  final double minShadowPowerWidth;
  final GlobalNoiseConfig globalNoise;
  final VertexDeformConfig vertexDeform;
  final List<bool> activeColors;

  WhatameshConfig copyWith({
    Offset? density,
    double? initialTime,
    double? shadowPower,
    double? minShadowPowerWidth,
    GlobalNoiseConfig? globalNoise,
    VertexDeformConfig? vertexDeform,
    List<bool>? activeColors,
  }) {
    return WhatameshConfig(
      density: density ?? this.density,
      initialTime: initialTime ?? this.initialTime,
      shadowPower: shadowPower ?? this.shadowPower,
      minShadowPowerWidth: minShadowPowerWidth ?? this.minShadowPowerWidth,
      globalNoise: globalNoise ?? this.globalNoise,
      vertexDeform: vertexDeform ?? this.vertexDeform,
      activeColors: activeColors ?? this.activeColors,
    );
  }

  List<WaveLayerConfig> buildWaveLayers(List<Color> colors) {
    assert(colors.length == 4, 'Whatamesh requires exactly 4 colors.');

    return List<WaveLayerConfig>.generate(colors.length - 1, (index) {
      final layerIndex = index + 1;
      final ratio = layerIndex / colors.length;
      return WaveLayerConfig(
        color: colors[layerIndex],
        noiseFreqX: 2 + ratio,
        noiseFreqY: 3 + ratio,
        noiseSpeed: 11 + 0.3 * layerIndex,
        noiseFlow: 6.5 + 0.3 * layerIndex,
        noiseSeed: vertexDeform.noiseSeed + 10 * layerIndex,
        noiseFloor: 0.1,
        noiseCeil: 0.63 + 0.07 * layerIndex,
      );
    });
  }
}
