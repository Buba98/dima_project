import 'package:flutter/material.dart';

class Activity {
  final String Function(BuildContext) name;
  final String value;

  Activity({required this.name, required this.value});
}
