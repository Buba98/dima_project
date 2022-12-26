import 'package:flutter/cupertino.dart';

class SelectionElement<T> {
  SelectionElement({
    required this.name,
    required this.selected,
    this.icon,
    this.element,
  });

  final String name;
  final T? element;
  bool selected;
  final IconData? icon;
}
