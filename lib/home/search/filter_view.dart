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
  });

  final TextEditingController otherActivity = TextEditingController();
  final Function(SelectionElement) addOtherActivity;
  final List<SelectionElement> activities;
  final Function(int change) onChangeActivity;
  final double priceValue;
  final Function(double) onChangePriceValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
