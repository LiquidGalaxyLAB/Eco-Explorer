import 'dart:math';
import 'package:fast_noise/fast_noise.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NoisePolygonGenerator {
  final int numVertices;
  final double radiusMean;
  final double noiseScale;
  final double noiseAmplitude;

  final PerlinNoise perlin;

  NoisePolygonGenerator({
    this.numVertices = 100,
    this.radiusMean = 3.0,
    this.noiseScale = 0.25,
    this.noiseAmplitude = 2.0,
  }) : perlin = PerlinNoise(
    seed: 42,
    frequency: 1.0,
  );

  List<LatLng> createPolygon(double lat, double lon) {
    List<LatLng> points = [];

    for (int i = 0; i < numVertices; i++) {
      double angle = 2 * pi * i / numVertices;

      // Replicates pnoise1(i * noise_scale)
      double noiseVal = perlin.getNoise3(i * noiseScale, 0.0, 0.0);

      // Optional: normalize [-1,1] → [0,1] to match Python behavior
      noiseVal = (noiseVal + 1) / 2;

      double radius = radiusMean + noiseAmplitude * noiseVal;

      double x = lon + radius * cos(angle);
      double y = lat + radius * sin(angle);

      points.add(LatLng(y, x));
    }

    // Close the polygon
    points.add(points.first);

    return points;
  }
}
