import 'dart:math';

import 'package:dima_project/utils/utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';

void main() {
  group('LatLng', () {
    test('Check distance correctly calculated', () {
      LatLng milan = LatLng(45.4654219, 9.1859243);

      LatLng naples = LatLng(40.853294, 14.305573);

      double calculatedDistanceInMeters = 659777.3;

      bool exceeded =
          ((max(distanceInMeters(milan, naples), calculatedDistanceInMeters) /
                      min(distanceInMeters(milan, naples),
                          calculatedDistanceInMeters)) -
                  1) >
              0.05;

      expect(exceeded, false);
    });
  });
}
