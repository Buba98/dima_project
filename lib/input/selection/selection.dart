import 'package:dima_project/constants.dart';
import 'package:dima_project/input/selection/selection_element.dart';
import 'package:dima_project/input/show_text.dart';
import 'package:flutter/material.dart';

class Selection extends StatelessWidget {
  const Selection({
    super.key,
    required this.elements,
    this.onChanged,
    this.direction = Axis.horizontal,
    this.spacing = spaceBetweenWidgets,
    this.rows = 2,
    this.baseColor = Colors.black12,
    this.title,
  });

  final List<SelectionElement> elements;
  final Function(int)? onChanged;
  final Axis direction;
  final double spacing;
  final int rows;
  final Color baseColor;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Text(
              title!,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          if (title != null) const Divider(),
          Wrap(
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
                    wight: (constraints.maxWidth - spacing * (rows - 1)) / rows,
                    centerText: true,
                    backgroundColor:
                        element.selected ? Colors.black26 : Colors.black12,
                    trailerIcon: element.icon,
                    text: element.name,
                  ),
                );
              },
            ).toList(),
          ),
        ],
      );
    });
  }
}
