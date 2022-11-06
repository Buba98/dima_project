import 'package:dima_project/input/selection/selection_element.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Selection extends StatelessWidget {
  Selection({
    super.key,
    required this.elements,
    this.onChanged,
    this.direction = Axis.horizontal,
    this.runSpacing = 30,
    this.spacing = 10,
    this.elementHeight = 50,
    this.elementWidth = 150,
    this.baseColor = Colors.black12,
    this.selectedAlpha = 120,
    this.notSelectedAlpha = 50,
    //TODO fontSize
  });

  final List<SelectionElement> elements;
  final Function(int)? onChanged;
  final Axis direction;
  final double runSpacing;
  final double spacing;
  final double elementHeight;
  final double elementWidth;
  final Color baseColor;
  final int selectedAlpha;
  final int notSelectedAlpha;

  @override
  Widget build(BuildContext context) {
    Color colorSelected = baseColor.withAlpha(selectedAlpha);
    Color colorNotSelected = baseColor.withAlpha(notSelectedAlpha);
    return Center(
      child: Wrap(
        direction: direction,
        runSpacing: runSpacing,
        spacing: spacing,
        children: elements.map((element) {
          return GestureDetector(
            onTap: () {
              if (onChanged == null) return;
              onChanged!(elements.indexOf(element));
            },
            child: SizedBox(
              height: elementHeight,
              width: elementWidth,
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20),
                  ),
                  color: element.selected ? colorSelected : colorNotSelected,
                ),
                child: Row(
                  children: [
                    if (element.icon != null)
                      Icon(
                        element.icon,
                      ),
                    if (element.icon != null)
                      const SizedBox(
                        width: 12,
                      ),
                    Expanded(
                      child: Text(
                        element.name,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
