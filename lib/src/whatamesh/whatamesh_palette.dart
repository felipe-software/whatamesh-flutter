import 'dart:math';

import 'package:flutter/material.dart';

class WhatameshPalette {
  const WhatameshPalette._();

  static const List<List<Color>> presets = <List<Color>>[
    <Color>[
      Color(0xFFC3E4FF),
      Color(0xFF6EC3F4),
      Color(0xFFEAE2FF),
      Color(0xFFB9BEFF),
    ],
    <Color>[
      Color(0xFF449CE4),
      Color(0xFF2F8BC1),
      Color(0xFFCCBEEE),
      Color(0xFF4C57F6),
    ],
    <Color>[
      Color(0xFFFFD6A5),
      Color(0xFFFFADAD),
      Color(0xFFCDB4DB),
      Color(0xFFA2D2FF),
    ],
    <Color>[
      Color(0xFFB8F2E6),
      Color(0xFFAED9E0),
      Color(0xFF5E6472),
      Color(0xFFFFEEDB),
    ],
  ];

  static List<Color> random([Random? random]) {
    final rng = random ?? Random();
    final palette = presets[rng.nextInt(presets.length)];
    return List<Color>.from(palette);
  }
}
