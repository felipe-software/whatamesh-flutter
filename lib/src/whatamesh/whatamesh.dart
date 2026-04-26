import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'model/whatamesh_config.dart';
import 'whatamesh_controller.dart';
import 'whatamesh_painter.dart';

class Whatamesh extends StatefulWidget {
  const Whatamesh({
    required this.colors,
    super.key,
    this.darkenTop = false,
    this.playing = true,
    this.density = const Offset(0.06, 0.16),
    this.config = const WhatameshConfig(),
    this.controller,
  }) : assert(colors.length == 4, 'Whatamesh requires exactly 4 colors.');

  final List<Color> colors;
  final bool darkenTop;
  final bool playing;
  final Offset density;
  final WhatameshConfig config;
  final WhatameshController? controller;

  @override
  State<Whatamesh> createState() => _WhatameshState();
}

class _WhatameshState extends State<Whatamesh>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  late WhatameshPainter _painter;
  Duration? _lastElapsed;
  WhatameshController? _internalController;

  WhatameshController get _controller =>
      widget.controller ?? _internalController!;

  @override
  void initState() {
    super.initState();
    _internalController = widget.controller == null
        ? WhatameshController(
            colors: widget.colors,
            darkenTop: widget.darkenTop,
            playing: widget.playing,
            config: widget.config,
          )
        : null;
    _controller.syncFromWidget(
      colors: widget.colors,
      darkenTop: widget.darkenTop,
      playing: widget.playing,
    );
    _painter = WhatameshPainter(
      controller: _controller,
      config: widget.config,
      density: widget.density,
    );
    _ticker = createTicker(_handleTick)..start();
  }

  @override
  void didUpdateWidget(covariant Whatamesh oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.controller != widget.controller) {
      if (oldWidget.controller == null && widget.controller != null) {
        _internalController?.dispose();
        _internalController = null;
      } else if (oldWidget.controller != null && widget.controller == null) {
        _internalController = WhatameshController(
          colors: widget.colors,
          darkenTop: widget.darkenTop,
          playing: widget.playing,
          config: widget.config,
        );
      }
    }

    _controller.syncFromWidget(
      colors: widget.colors,
      darkenTop: widget.darkenTop,
      playing: widget.playing,
    );
    _painter
      ..controller = _controller
      ..config = widget.config
      ..density = widget.density;
  }

  void _handleTick(Duration elapsed) {
    final previous = _lastElapsed;
    _lastElapsed = elapsed;
    if (previous == null) {
      return;
    }
    final delta = (elapsed - previous).inMicroseconds / 1000;
    _controller.advance(delta);
  }

  @override
  void dispose() {
    _ticker.dispose();
    _internalController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: SizedBox.expand(
        child: CustomPaint(painter: _painter, isComplex: true),
      ),
    );
  }
}
