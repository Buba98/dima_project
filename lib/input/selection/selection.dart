import 'package:dima_project/input/selection/selection_element.dart';
import 'package:flutter/material.dart';

import '../show_text.dart';

class Selection extends StatelessWidget {
  const Selection({
    super.key,
    required this.elements,
    this.onChanged,
    this.direction = Axis.horizontal,
    this.spacing = 10,
    this.elementWidth = 150,
    this.baseColor = Colors.black12,
  });

  final List<SelectionElement> elements;
  final Function(int)? onChanged;
  final Axis direction;
  final double spacing;
  final double elementWidth;
  final Color baseColor;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: direction,
      runSpacing: spacing,
      spacing: spacing,
      children: elements.map(
        (element) {
          return GestureDetector(
            onTap: () {
              if (onChanged == null) return;
              onChanged!(elements.indexOf(element));
            },
            child: ShowText(
              wight: elementWidth,
              centerText: true,
              backgroundColor:
                  element.selected ? Colors.black26 : Colors.black12,
              trailerIcon: element.icon,
              text: element.name,
            ),
          );
        },
      ).toList(),
    );
  }
}
