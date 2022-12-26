import 'package:dima_project/generated/l10n.dart';
import 'package:dima_project/input/selection/selection.dart';
import 'package:dima_project/input/selection/selection_element.dart';
import 'package:dima_project/input/show_text.dart';
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
  final Function(SelectionElement<String>) addOtherActivity;
  final List<SelectionElement> activities;
  final Function(int change) onChangeActivity;
  final double priceValue;
  final Function(double) onChangePriceValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ShowText(
          text: S.of(context).maxPrice,
          backgroundColor: Colors.transparent,
        ),
        Slider(
          value: priceValue,
          max: 100,
          min: 0,
          divisions: 100 * 2,
          label: priceValue == 0
              ? S.of(context).noFilter
              : priceValue.toStringAsFixed(1),
          onChanged: onChangePriceValue,
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Selection(
              onChanged: onChangeActivity,
              elements: activities,
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
          hintText: S.of(context).addFilter,
          iconButton: Icons.add,
        ),
      ],
    );
  }
}
