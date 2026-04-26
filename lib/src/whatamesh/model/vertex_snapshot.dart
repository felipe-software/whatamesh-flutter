import 'dart:typed_data';
import 'dart:ui' as ui;

class VertexSnapshot {
  VertexSnapshot({
    required this.size,
    required this.positions,
    required this.colors,
    required this.indices,
  });

  final ui.Size size;
  final Float32List positions;
  final Int32List colors;
  final Uint16List indices;
}
