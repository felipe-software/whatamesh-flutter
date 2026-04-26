import 'dart:ui';

import 'package:app/src/whatamesh/mesh_geometry.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('mesh geometry matches density formula', () {
    final geometry = MeshGeometry.fromDensity(
      const Size(1000, 500),
      const Offset(0.06, 0.16),
    );

    expect(geometry.xSegments, 60);
    expect(geometry.ySegments, 80);
    expect(geometry.vertexCount, 4941);
    expect(geometry.indices.length, 28800);
  });
}
