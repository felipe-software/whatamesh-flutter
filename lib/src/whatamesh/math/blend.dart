double clamp01(double value) {
  if (value < 0) {
    return 0;
  }
  if (value > 1) {
    return 1;
  }
  return value;
}

double mix(double a, double b, double t) {
  return a * (1 - t) + b * t;
}

double smoothstep(double edge0, double edge1, double x) {
  final t = clamp01((x - edge0) / (edge1 - edge0));
  return t * t * (3 - 2 * t);
}

({double r, double g, double b}) blendNormal(
  ({double r, double g, double b}) base,
  ({double r, double g, double b}) blend,
  double opacity,
) {
  return (
    r: blend.r * opacity + base.r * (1 - opacity),
    g: blend.g * opacity + base.g * (1 - opacity),
    b: blend.b * opacity + base.b * (1 - opacity),
  );
}
