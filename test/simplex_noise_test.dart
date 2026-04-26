import 'package:app/src/whatamesh/noise/simplex_noise.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('simplex noise stays deterministic', () {
    expect(SimplexNoise.noise3(0, 0, 0), closeTo(0, 0.000001));
    expect(
      SimplexNoise.noise3(0.1, 0.2, 0.3),
      closeTo(0.6358903679999998, 0.000001),
    );
    expect(
      SimplexNoise.normalized3(1.25, 0.5, 2.0),
      closeTo(0.3269212565104167, 0.000001),
    );
  });

  test('darken top factor follows shader curve', () {
    expect(
      SimplexNoise.darkenTopFactor(0.2, 0.9, 6),
      closeTo(0.41787916749061804, 0.000001),
    );
  });
}
