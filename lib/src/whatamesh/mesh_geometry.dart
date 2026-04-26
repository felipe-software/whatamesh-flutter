import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

class MeshGeometry {
  MeshGeometry({
    required this.size,
    required this.xSegments,
    required this.ySegments,
  }) : vertexCount = (xSegments + 1) * (ySegments + 1),
       triangleCount = xSegments * ySegments * 2,
       uv = Float32List((xSegments + 1) * (ySegments + 1) * 2),
       uvNorm = Float32List((xSegments + 1) * (ySegments + 1) * 2),
       positions = Float32List((xSegments + 1) * (ySegments + 1) * 2),
       colors = Int32List((xSegments + 1) * (ySegments + 1)),
       indices = Uint16List(xSegments * ySegments * 6) {
    _build();
  }

  factory MeshGeometry.fromDensity(ui.Size size, ui.Offset density) {
    final xSegments = math.max(1, (size.width * density.dx).ceil());
    final ySegments = math.max(1, (size.height * density.dy).ceil());
    return MeshGeometry(size: size, xSegments: xSegments, ySegments: ySegments);
  }

  final ui.Size size;
  final int xSegments;
  final int ySegments;
  final int vertexCount;
  final int triangleCount;
  final Float32List uv;
  final Float32List uvNorm;
  final Float32List positions;
  final Int32List colors;
  final Uint16List indices;

  void _build() {
    var indexOffset = 0;

    for (var y = 0; y <= ySegments; y++) {
      for (var x = 0; x <= xSegments; x++) {
        final vertex = y * (xSegments + 1) + x;
        final u = x / xSegments;
        final v = 1 - y / ySegments;
        uv[vertex * 2] = u;
        uv[vertex * 2 + 1] = v;
        uvNorm[vertex * 2] = u * 2 - 1;
        uvNorm[vertex * 2 + 1] = 1 - (y / ySegments) * 2;

        if (x < xSegments && y < ySegments) {
          final start = y * xSegments + x;
          indices[indexOffset++] = vertex;
          indices[indexOffset++] = vertex + 1 + xSegments;
          indices[indexOffset++] = vertex + 1;
          indices[indexOffset++] = vertex + 1;
          indices[indexOffset++] = vertex + 1 + xSegments;
          indices[indexOffset++] = vertex + 2 + xSegments;
          assert(start >= 0);
        }
      }
    }
  }
}
