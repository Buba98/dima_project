import 'package:dima_project/generated/l10n.dart';
import 'package:dima_project/input/selection/selection.dart';
import 'package:dima_project/input/selection/selection_element.dart';
import 'package:dima_project/input/text_input_button.dart';
import 'package:flutter/material.dart';

class FilterView extends StatelessWidget {
  FilterView({
    super.key,
    required this.addOtherActivity,
    required this.activities,
    required this.onChangeActivity,
    required this.priceValue,
    required this.onChangePriceValue,
    required this.distanceValue,
    required this.onChangeDistanceValue,
  });

  final TextEditingController otherActivity = TextEditingController();
  final Function(SelectionElement<String>) addOtherActivity;
  final List<SelectionElement<String>> activities;
  final Function(int change) onChangeActivity;
  final double priceValue;
  final Function(double) onChangePriceValue;
  final double distanceValue;
  final Function(double) onChangeDistanceValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).maxDistance,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
        Slider(
          value: distanceValue,
          max: 2000,
          min: 0,
          divisions: 20,
          label: distanceValue == 0 || distanceValue == 2000
              ? S.of(context).noFilter
              : '${distanceValue.toInt()}${S.of(context).m}',
          onChanged: onChangeDistanceValue,
        ),
        Text(
          S.of(context).maxPrice,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
        Slider(
          value: priceValue,
          max: 100,
          min: 0,
          divisions: 100,
          label: priceValue == 0 || priceValue == 100
              ? S.of(context).noFilter
              : '\$${priceValue.toInt()}',
          onChanged: onChangePriceValue,
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Selection(
              onChanged: onChangeActivity,
              elements: activities,
              title: S.of(context).activities,
            ),
          ),
        ),
        TextInputButton(
          textEditingController: otherActivity,
          onTap: () {
            if (otherActivity.text.isEmpty) {
              return;
            }

            for (SelectionElement activity in activities) {
              if (activity.name == otherActivity.text) {
                otherActivity.clear();
                return;
              }
            }

            addOtherActivity(SelectionElement(
              name: otherActivity.text,
              selected: true,
              element: otherActivity.text,
            ));

            otherActivity.clear();
          },
          hintText: S.of(context).addActivity,
          iconButton: Icons.add,
        ),
      ],
    );
  }
}
