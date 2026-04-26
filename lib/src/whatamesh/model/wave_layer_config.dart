import 'package:flutter/material.dart';

@immutable
class GlobalNoiseConfig {
  const GlobalNoiseConfig({
    this.noiseFreqX = 0.00014,
    this.noiseFreqY = 0.00029,
    this.noiseSpeed = 0.000005,
  });

  final double noiseFreqX;
  final double noiseFreqY;
  final double noiseSpeed;

  GlobalNoiseConfig copyWith({
    double? noiseFreqX,
    double? noiseFreqY,
    double? noiseSpeed,
  }) {
    return GlobalNoiseConfig(
      noiseFreqX: noiseFreqX ?? this.noiseFreqX,
      noiseFreqY: noiseFreqY ?? this.noiseFreqY,
      noiseSpeed: noiseSpeed ?? this.noiseSpeed,
    );
  }
}

@immutable
class VertexDeformConfig {
  const VertexDeformConfig({
    this.incline = 0,
    this.offsetTop = -0.5,
    this.offsetBottom = -0.5,
    this.noiseFreqX = 3,
    this.noiseFreqY = 4,
    this.noiseAmp = 320,
    this.noiseSpeed = 10,
    this.noiseFlow = 3,
    this.noiseSeed = 5,
  });

  final double incline;
  final double offsetTop;
  final double offsetBottom;
  final double noiseFreqX;
  final double noiseFreqY;
  final double noiseAmp;
  final double noiseSpeed;
  final double noiseFlow;
  final double noiseSeed;

  VertexDeformConfig copyWith({
    double? incline,
    double? offsetTop,
    double? offsetBottom,
    double? noiseFreqX,
    double? noiseFreqY,
    double? noiseAmp,
    double? noiseSpeed,
    double? noiseFlow,
    double? noiseSeed,
  }) {
    return VertexDeformConfig(
      incline: incline ?? this.incline,
      offsetTop: offsetTop ?? this.offsetTop,
      offsetBottom: offsetBottom ?? this.offsetBottom,
      noiseFreqX: noiseFreqX ?? this.noiseFreqX,
      noiseFreqY: noiseFreqY ?? this.noiseFreqY,
      noiseAmp: noiseAmp ?? this.noiseAmp,
      noiseSpeed: noiseSpeed ?? this.noiseSpeed,
      noiseFlow: noiseFlow ?? this.noiseFlow,
      noiseSeed: noiseSeed ?? this.noiseSeed,
    );
  }
}

@immutable
class WaveLayerConfig {
  const WaveLayerConfig({
    required this.color,
    required this.noiseFreqX,
    required this.noiseFreqY,
    required this.noiseSpeed,
    required this.noiseFlow,
    required this.noiseSeed,
    required this.noiseFloor,
    required this.noiseCeil,
  });

  final Color color;
  final double noiseFreqX;
  final double noiseFreqY;
  final double noiseSpeed;
  final double noiseFlow;
  final double noiseSeed;
  final double noiseFloor;
  final double noiseCeil;

  WaveLayerConfig copyWith({
    Color? color,
    double? noiseFreqX,
    double? noiseFreqY,
    double? noiseSpeed,
    double? noiseFlow,
    double? noiseSeed,
    double? noiseFloor,
    double? noiseCeil,
  }) {
    return WaveLayerConfig(
      color: color ?? this.color,
      noiseFreqX: noiseFreqX ?? this.noiseFreqX,
      noiseFreqY: noiseFreqY ?? this.noiseFreqY,
      noiseSpeed: noiseSpeed ?? this.noiseSpeed,
      noiseFlow: noiseFlow ?? this.noiseFlow,
      noiseSeed: noiseSeed ?? this.noiseSeed,
      noiseFloor: noiseFloor ?? this.noiseFloor,
      noiseCeil: noiseCeil ?? this.noiseCeil,
    );
  }
}
