import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'math/blend.dart';
import 'mesh_geometry.dart';
import 'model/vertex_snapshot.dart';
import 'model/whatamesh_config.dart';
import 'noise/simplex_noise.dart';
import 'whatamesh_controller.dart';

class WhatameshPainter extends CustomPainter {
  WhatameshPainter({
    required this.controller,
    required this.config,
    required this.density,
  }) : super(repaint: controller);

  WhatameshController controller;
  WhatameshConfig config;
  Offset density;

  MeshGeometry? _geometry;
  ui.Size? _lastSize;
  VertexSnapshot? _lastSnapshot;

  @override
  void paint(Canvas canvas, ui.Size size) {
    if (size.isEmpty) {
      return;
    }

    final snapshot = _computeSnapshot(size);
    final vertices = ui.Vertices.raw(
      ui.VertexMode.triangles,
      snapshot.positions,
      colors: snapshot.colors,
      indices: snapshot.indices,
    );

    canvas.drawVertices(vertices, BlendMode.srcOver, Paint());
  }

  VertexSnapshot debugSnapshotForSize(ui.Size size) => _computeSnapshot(size);

  VertexSnapshot _computeSnapshot(ui.Size size) {
    if (_geometry == null || _lastSize != size) {
      _geometry = MeshGeometry.fromDensity(size, density);
      _lastSize = size;
    }

    final geometry = _geometry!;
    final colors = controller.colors;
    final shadowPower = size.width < config.minShadowPowerWidth
        ? 5.0
        : config.shadowPower;
    final layers = config.buildWaveLayers(colors);
    final baseColor = _toRgb(colors.first);
    final positions = geometry.positions;
    final packedColors = geometry.colors;
    final width = size.width;
    final height = size.height;
    final global = config.globalNoise;
    final deform = config.vertexDeform;
    final time = controller.time * global.noiseSpeed;

    for (var vertex = 0; vertex < geometry.vertexCount; vertex++) {
      final uvX = geometry.uv[vertex * 2];
      final uvY = geometry.uv[vertex * 2 + 1];
      final uvNormX = geometry.uvNorm[vertex * 2];
      final uvNormY = geometry.uvNorm[vertex * 2 + 1];

      final noiseCoordX = width * uvNormX * global.noiseFreqX;
      final noiseCoordY = height * uvNormY * global.noiseFreqY;

      final tilt = height / 2 * uvNormY;
      final incline = width * uvNormX / 2 * deform.incline;
      final offset =
          width /
          2 *
          deform.incline *
          mix(deform.offsetBottom, deform.offsetTop, uvY);

      var vertexNoise =
          SimplexNoise.noise3(
            noiseCoordX * deform.noiseFreqX + time * deform.noiseFlow,
            noiseCoordY * deform.noiseFreqY,
            time * deform.noiseSpeed + deform.noiseSeed,
          ) *
          deform.noiseAmp;
      // vertexNoise *= 1 - math.pow(uvNormY.abs(), 2).toDouble();
      // https://github.com/jordienr/whatamesh/issues/5
      vertexNoise = smoothstep(0.0, 1.0, vertexNoise);
      vertexNoise = math.max(0, vertexNoise);

      final posY = tilt + incline + vertexNoise - offset;
      final screenX = uvX * width;
      final screenY = height / 2 - posY;

      positions[vertex * 2] = screenX;
      positions[vertex * 2 + 1] = screenY;

      var rgb = config.activeColors.first
          ? baseColor
          : (r: 0.0, g: 0.0, b: 0.0);

      for (var i = 0; i < layers.length; i++) {
        final activeIndex = i + 1;
        if (activeIndex >= config.activeColors.length ||
            !config.activeColors[activeIndex]) {
          continue;
        }

        final layer = layers[i];
        final layerNoise = smoothstep(
          layer.noiseFloor,
          layer.noiseCeil,
          SimplexNoise.normalized3(
            noiseCoordX * layer.noiseFreqX + time * layer.noiseFlow,
            noiseCoordY * layer.noiseFreqY,
            time * layer.noiseSpeed + layer.noiseSeed,
          ),
        );

        rgb = blendNormal(
          rgb,
          _toRgb(layer.color),
          math.pow(layerNoise, 4).toDouble(),
        );
      }

      if (controller.darkenTop) {
        final stX = screenX / width;
        final stY = 1 - (screenY / height);
        rgb = (
          r: rgb.r,
          g: clamp01(
            rgb.g - SimplexNoise.darkenTopFactor(stX, stY, shadowPower),
          ),
          b: rgb.b,
        );
      }

      packedColors[vertex] = _packColor(rgb.r, rgb.g, rgb.b);
    }

    _lastSnapshot = VertexSnapshot(
      size: size,
      positions: positions,
      colors: packedColors,
      indices: geometry.indices,
    );
    return _lastSnapshot!;
  }

  ({double r, double g, double b}) _toRgb(Color color) {
    return (r: color.r, g: color.g, b: color.b);
  }

  int _packColor(double r, double g, double b) {
    final red = (clamp01(r) * 255).round();
    final green = (clamp01(g) * 255).round();
    final blue = (clamp01(b) * 255).round();
    return Color.fromARGB(255, red, green, blue).toARGB32();
  }

  @override
  bool shouldRepaint(covariant WhatameshPainter oldDelegate) {
    return oldDelegate.controller != controller ||
        oldDelegate.config != config ||
        oldDelegate.density != density;
  }
}
