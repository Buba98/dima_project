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
    this.title,
    this.errorTitle,
    this.error = false,
  });

  final List<SelectionElement> elements;
  final Function(int)? onChanged;
  final Axis direction;
  final double spacing;
  final int rows;
  final String? title;
  final bool error;
  final String? errorTitle;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Text(
              error ? errorTitle ?? title! : title!,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: error
                    ? Theme.of(context).errorColor
                    : Theme.of(context).primaryColor,
              ),
            ),
          if (title != null) const Divider(),
          Wrap(
            direction: direction,
            runSpacing: spacing,
            spacing: spacing,
            children: elements.map(
              (element) {
                return ShowText(
                  wight: (constraints.maxWidth - spacing * (rows - 1)) / rows,
                  onPressed: () {
                    if (onChanged == null) return;
                    onChanged!(elements.indexOf(element));
                  },
                  centerText: true,
                  backgroundColor: (error
                          ? Theme.of(context).errorColor
                          : Theme.of(context).primaryColor)
                      .withOpacity(element.selected ? .26 : .12),
                  trailerIcon: element.icon,
                  text: element.name,
                );
              },
            ).toList(),
          ),
        ],
      );
    });
  }
}
