import 'dart:math';

import 'package:flutter/material.dart';

import '../../whatamesh.dart';

class WhatameshDemoPage extends StatefulWidget {
  const WhatameshDemoPage({super.key});

  @override
  State<WhatameshDemoPage> createState() => _WhatameshDemoPageState();
}

class _WhatameshDemoPageState extends State<WhatameshDemoPage> {
  late final WhatameshController _controller;
  late List<Color> _colors;
  var _darkenTop = false;
  var _playing = true;
  var _amp = 320.0;
  var _densityX = 0.06;
  var _densityY = 0.16;

  @override
  void initState() {
    super.initState();
    _colors = WhatameshPalette.random(Random(7));
    _controller = WhatameshController(
      colors: _colors,
      darkenTop: _darkenTop,
      playing: _playing,
      config: _config,
    );
  }

  WhatameshConfig get _config => WhatameshConfig(
    density: Offset(_densityX, _densityY),
    vertexDeform: const VertexDeformConfig().copyWith(noiseAmp: _amp),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _editColor(int index) async {
    final color = await showDialog<Color>(
      context: context,
      builder: (context) => _ColorEditorDialog(initialColor: _colors[index]),
    );

    if (color == null) {
      return;
    }

    setState(() {
      _colors[index] = color;
      _controller.setColors(_colors);
    });
  }

  void _randomize() {
    setState(() {
      _colors = WhatameshPalette.random();
      _controller.setColors(_colors);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'whatamesh / flutter',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w300,
                      letterSpacing: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Port 1:1 do renderer original em mesh + noise + color blending no Flutter.',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final isCompact = constraints.maxWidth < 900;
                        final preview = _buildPreviewCard();
                        final controls = _buildControlsCard(theme);
                        if (isCompact) {
                          return ListView(
                            children: [
                              SizedBox(height: 360, child: preview),
                              const SizedBox(height: 16),
                              controls,
                            ],
                          );
                        }
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(flex: 3, child: preview),
                            const SizedBox(width: 16),
                            Expanded(flex: 2, child: controls),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPreviewCard() {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x3D000000),
            blurRadius: 40,
            offset: Offset(0, 20),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          fit: StackFit.expand,
          children: [
            DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF101427), Color(0xFF090B14)],
                ),
              ),
              child: Whatamesh(
                colors: _colors,
                darkenTop: _darkenTop,
                playing: _playing,
                density: Offset(_densityX, _densityY),
                config: _config,
                controller: _controller,
              ),
            ),
            Positioned(
              left: 20,
              top: 20,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.28),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: Colors.white24),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Text(
                    _playing ? 'Animating' : 'Paused',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlsCard(ThemeData theme) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF0D1120),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Controls', style: theme.textTheme.titleLarge),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: List<Widget>.generate(_colors.length, (index) {
                  return InkWell(
                    onTap: () => _editColor(index),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: 88,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF14192C),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 42,
                            decoration: BoxDecoration(
                              color: _colors[index],
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '#${_colors[index].toARGB32().toRadixString(16).substring(2).toUpperCase()}',
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  FilledButton(
                    onPressed: () {
                      setState(() {
                        _playing = !_playing;
                        _controller.togglePlayPause();
                      });
                    },
                    child: Text(_playing ? 'Pause' : 'Play'),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _darkenTop = !_darkenTop;
                        _controller.setDarkenTop(_darkenTop);
                      });
                    },
                    child: Text(
                      _darkenTop ? 'Darken Top On' : 'Darken Top Off',
                    ),
                  ),
                  OutlinedButton(
                    onPressed: _randomize,
                    child: const Text('Randomize'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _LabeledSlider(
                label: 'Amplitude',
                value: _amp,
                min: 0,
                max: 480,
                onChanged: (value) {
                  setState(() {
                    _amp = value;
                  });
                },
              ),
              _LabeledSlider(
                label: 'Density X',
                value: _densityX,
                min: 0.02,
                max: 0.12,
                onChanged: (value) {
                  setState(() {
                    _densityX = value;
                  });
                },
              ),
              _LabeledSlider(
                label: 'Density Y',
                value: _densityY,
                min: 0.06,
                max: 0.24,
                onChanged: (value) {
                  setState(() {
                    _densityY = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LabeledSlider extends StatelessWidget {
  const _LabeledSlider({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  final String label;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label  ${value.toStringAsFixed(2)}'),
        Slider(value: value, min: min, max: max, onChanged: onChanged),
      ],
    );
  }
}

class _ColorEditorDialog extends StatefulWidget {
  const _ColorEditorDialog({required this.initialColor});

  final Color initialColor;

  @override
  State<_ColorEditorDialog> createState() => _ColorEditorDialogState();
}

class _ColorEditorDialogState extends State<_ColorEditorDialog> {
  late HSVColor _color;

  @override
  void initState() {
    super.initState();
    _color = HSVColor.fromColor(widget.initialColor);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit color'),
      content: SizedBox(
        width: 320,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 72,
              decoration: BoxDecoration(
                color: _color.toColor(),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            const SizedBox(height: 16),
            _slider('Hue', _color.hue, 0, 360, (value) {
              setState(() {
                _color = _color.withHue(value);
              });
            }),
            _slider('Saturation', _color.saturation, 0, 1, (value) {
              setState(() {
                _color = _color.withSaturation(value);
              });
            }),
            _slider('Value', _color.value, 0, 1, (value) {
              setState(() {
                _color = _color.withValue(value);
              });
            }),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(_color.toColor()),
          child: const Text('Apply'),
        ),
      ],
    );
  }

  Widget _slider(
    String label,
    double value,
    double min,
    double max,
    ValueChanged<double> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label  ${value.toStringAsFixed(2)}'),
        Slider(value: value, min: min, max: max, onChanged: onChanged),
      ],
    );
  }
}
