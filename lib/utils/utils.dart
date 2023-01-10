import 'dart:math';

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}

double distanceInMeters(LatLng latLng1, LatLng latLng2) {
  double dlon = latLng2.longitudeInRad - latLng1.longitudeInRad;
  double dlat = latLng2.latitudeInRad - latLng1.latitudeInRad;

  double a = pow(sin(dlat / 2), 2) +
      cos(latLng1.latitudeInRad) *
          cos(latLng2.latitudeInRad) *
          pow(sin(dlon / 2), 2);

  double c = 2 * asin(asin(sqrt(a)));

  return c * 6371 * 1000;
}

String printDate(DateTime dateTime) =>
    '${dateTime.day} / ${dateTime.month} / ${dateTime.year}';

String printDuration(Duration duration) =>
    '${duration.inMinutes ~/ 60} : ${duration.inMinutes % 60 > 9 ? duration.inMinutes % 60 : '0${duration.inMinutes % 60}'}';

String printTime(DateTime dateTime) =>
    '${dateTime.hour > 9 ? dateTime.hour : '0${dateTime.hour}'} : ${dateTime.minute > 9 ? dateTime.minute : '0${dateTime.minute}'}';

bool isTablet(BuildContext context) =>
    MediaQuery.of(context).size.shortestSide > 600;

bool isWide(BoxConstraints constraints) => constraints.maxWidth > 600;

LatLng locationDataToLatLng(LocationData locationData) =>
    LatLng(locationData.latitude!, locationData.longitude!);
