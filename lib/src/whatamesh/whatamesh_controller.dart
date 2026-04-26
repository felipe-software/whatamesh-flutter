import 'package:flutter/material.dart';

import 'model/whatamesh_config.dart';

class WhatameshController extends ChangeNotifier {
  WhatameshController({
    required List<Color> colors,
    required bool darkenTop,
    required bool playing,
    required WhatameshConfig config,
  }) : assert(colors.length == 4, 'Whatamesh requires exactly 4 colors.'),
       _colors = List<Color>.from(colors),
       _darkenTop = darkenTop,
       _playing = playing,
       _time = config.initialTime;

  List<Color> _colors;
  bool _darkenTop;
  bool _playing;
  double _time;

  List<Color> get colors => List<Color>.unmodifiable(_colors);
  bool get darkenTop => _darkenTop;
  bool get playing => _playing;
  double get time => _time;

  void play() {
    if (_playing) {
      return;
    }
    _playing = true;
    notifyListeners();
  }

  void pause() {
    if (!_playing) {
      return;
    }
    _playing = false;
    notifyListeners();
  }

  void togglePlayPause() {
    _playing = !_playing;
    notifyListeners();
  }

  void setColors(List<Color> colors) {
    assert(colors.length == 4, 'Whatamesh requires exactly 4 colors.');
    _colors = List<Color>.from(colors);
    notifyListeners();
  }

  void setDarkenTop(bool value) {
    if (_darkenTop == value) {
      return;
    }
    _darkenTop = value;
    notifyListeners();
  }

  void setTime(double value) {
    _time = value;
    notifyListeners();
  }

  void syncFromWidget({
    required List<Color> colors,
    required bool darkenTop,
    required bool playing,
  }) {
    var changed = false;

    if (_colors.length != colors.length) {
      _colors = List<Color>.from(colors);
      changed = true;
    } else {
      for (var i = 0; i < colors.length; i++) {
        if (_colors[i] != colors[i]) {
          _colors = List<Color>.from(colors);
          changed = true;
          break;
        }
      }
    }

    if (_darkenTop != darkenTop) {
      _darkenTop = darkenTop;
      changed = true;
    }

    if (_playing != playing) {
      _playing = playing;
      changed = true;
    }

    if (changed) {
      notifyListeners();
    }
  }

  void advance(double deltaMilliseconds) {
    if (!_playing || deltaMilliseconds <= 0) {
      return;
    }
    _time += deltaMilliseconds;
    notifyListeners();
  }
}
