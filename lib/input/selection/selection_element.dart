import 'package:flutter/cupertino.dart';

class SelectionElement {
  SelectionElement({required this.name, required this.selected, this.icon});

  final String name;
  bool selected;
  final IconData? icon;
}
