import 'dart:math' as math;

class SimplexNoise {
  const SimplexNoise._();

  static const List<int> _perm = <int>[
    151,
    160,
    137,
    91,
    90,
    15,
    131,
    13,
    201,
    95,
    96,
    53,
    194,
    233,
    7,
    225,
    140,
    36,
    103,
    30,
    69,
    142,
    8,
    99,
    37,
    240,
    21,
    10,
    23,
    190,
    6,
    148,
    247,
    120,
    234,
    75,
    0,
    26,
    197,
    62,
    94,
    252,
    219,
    203,
    117,
    35,
    11,
    32,
    57,
    177,
    33,
    88,
    237,
    149,
    56,
    87,
    174,
    20,
    125,
    136,
    171,
    168,
    68,
    175,
    74,
    165,
    71,
    134,
    139,
    48,
    27,
    166,
    77,
    146,
    158,
    231,
    83,
    111,
    229,
    122,
    60,
    211,
    133,
    230,
    220,
    105,
    92,
    41,
    55,
    46,
    245,
    40,
    244,
    102,
    143,
    54,
    65,
    25,
    63,
    161,
    1,
    216,
    80,
    73,
    209,
    76,
    132,
    187,
    208,
    89,
    18,
    169,
    200,
    196,
    135,
    130,
    116,
    188,
    159,
    86,
    164,
    100,
    109,
    198,
    173,
    186,
    3,
    64,
    52,
    217,
    226,
    250,
    124,
    123,
    5,
    202,
    38,
    147,
    118,
    126,
    255,
    82,
    85,
    212,
    207,
    206,
    59,
    227,
    47,
    16,
    58,
    17,
    182,
    189,
    28,
    42,
    223,
    183,
    170,
    213,
    119,
    248,
    152,
    2,
    44,
    154,
    163,
    70,
    221,
    153,
    101,
    155,
    167,
    43,
    172,
    9,
    129,
    22,
    39,
    253,
    19,
    98,
    108,
    110,
    79,
    113,
    224,
    232,
    178,
    185,
    112,
    104,
    218,
    246,
    97,
    228,
    251,
    34,
    242,
    193,
    238,
    210,
    144,
    12,
    191,
    179,
    162,
    241,
    81,
    51,
    145,
    235,
    249,
    14,
    239,
    107,
    49,
    192,
    214,
    31,
    181,
    199,
    106,
    157,
    184,
    84,
    204,
    176,
    115,
    121,
    50,
    45,
    127,
    4,
    150,
    254,
    138,
    236,
    205,
    93,
    222,
    114,
    67,
    29,
    24,
    72,
    243,
    141,
    128,
    195,
    78,
    66,
    215,
    61,
    156,
    180,
  ];

  static const List<List<double>> _grad3 = <List<double>>[
    <double>[1, 1, 0],
    <double>[-1, 1, 0],
    <double>[1, -1, 0],
    <double>[-1, -1, 0],
    <double>[1, 0, 1],
    <double>[-1, 0, 1],
    <double>[1, 0, -1],
    <double>[-1, 0, -1],
    <double>[0, 1, 1],
    <double>[0, -1, 1],
    <double>[0, 1, -1],
    <double>[0, -1, -1],
  ];

  static int _fastFloor(double value) =>
      value > 0 ? value.toInt() : value.toInt() - 1;

  static int _p(int index) => _perm[index & 255];

  static double _dot(List<double> gradient, double x, double y, double z) {
    return gradient[0] * x + gradient[1] * y + gradient[2] * z;
  }

  static double noise3(double xin, double yin, double zin) {
    const f3 = 1.0 / 3.0;
    const g3 = 1.0 / 6.0;

    final s = (xin + yin + zin) * f3;
    final i = _fastFloor(xin + s);
    final j = _fastFloor(yin + s);
    final k = _fastFloor(zin + s);

    final t = (i + j + k) * g3;
    final x0 = xin - (i - t);
    final y0 = yin - (j - t);
    final z0 = zin - (k - t);

    int i1;
    int j1;
    int k1;
    int i2;
    int j2;
    int k2;

    if (x0 >= y0) {
      if (y0 >= z0) {
        i1 = 1;
        j1 = 0;
        k1 = 0;
        i2 = 1;
        j2 = 1;
        k2 = 0;
      } else if (x0 >= z0) {
        i1 = 1;
        j1 = 0;
        k1 = 0;
        i2 = 1;
        j2 = 0;
        k2 = 1;
      } else {
        i1 = 0;
        j1 = 0;
        k1 = 1;
        i2 = 1;
        j2 = 0;
        k2 = 1;
      }
    } else if (y0 < z0) {
      i1 = 0;
      j1 = 0;
      k1 = 1;
      i2 = 0;
      j2 = 1;
      k2 = 1;
    } else if (x0 < z0) {
      i1 = 0;
      j1 = 1;
      k1 = 0;
      i2 = 0;
      j2 = 1;
      k2 = 1;
    } else {
      i1 = 0;
      j1 = 1;
      k1 = 0;
      i2 = 1;
      j2 = 1;
      k2 = 0;
    }

    final x1 = x0 - i1 + g3;
    final y1 = y0 - j1 + g3;
    final z1 = z0 - k1 + g3;
    final x2 = x0 - i2 + 2 * g3;
    final y2 = y0 - j2 + 2 * g3;
    final z2 = z0 - k2 + 2 * g3;
    final x3 = x0 - 1 + 3 * g3;
    final y3 = y0 - 1 + 3 * g3;
    final z3 = z0 - 1 + 3 * g3;

    final ii = i & 255;
    final jj = j & 255;
    final kk = k & 255;
    final gi0 = _p(ii + _p(jj + _p(kk))) % 12;
    final gi1 = _p(ii + i1 + _p(jj + j1 + _p(kk + k1))) % 12;
    final gi2 = _p(ii + i2 + _p(jj + j2 + _p(kk + k2))) % 12;
    final gi3 = _p(ii + 1 + _p(jj + 1 + _p(kk + 1))) % 12;

    var n0 = 0.0;
    var n1 = 0.0;
    var n2 = 0.0;
    var n3 = 0.0;

    var t0 = 0.6 - x0 * x0 - y0 * y0 - z0 * z0;
    if (t0 > 0) {
      t0 *= t0;
      n0 = t0 * t0 * _dot(_grad3[gi0], x0, y0, z0);
    }

    var t1 = 0.6 - x1 * x1 - y1 * y1 - z1 * z1;
    if (t1 > 0) {
      t1 *= t1;
      n1 = t1 * t1 * _dot(_grad3[gi1], x1, y1, z1);
    }

    var t2 = 0.6 - x2 * x2 - y2 * y2 - z2 * z2;
    if (t2 > 0) {
      t2 *= t2;
      n2 = t2 * t2 * _dot(_grad3[gi2], x2, y2, z2);
    }

    var t3 = 0.6 - x3 * x3 - y3 * y3 - z3 * z3;
    if (t3 > 0) {
      t3 *= t3;
      n3 = t3 * t3 * _dot(_grad3[gi3], x3, y3, z3);
    }

    return 32.0 * (n0 + n1 + n2 + n3).clamp(-1.0, 1.0);
  }

  static double normalized3(double x, double y, double z) {
    return noise3(x, y, z) / 2 + 0.5;
  }

  static double darkenTopFactor(double x, double y, double shadowPower) {
    final value = math.max(0.0, y + math.sin(-12.0) * x);
    return math.pow(value, shadowPower).toDouble() * 0.4;
  }
}
