import 'package:dima_project/constants.dart';
import 'package:dima_project/input/selection/selection.dart';
import 'package:dima_project/input/selection/selection_element.dart';
import 'package:dima_project/input/show_text.dart';
import 'package:dima_project/input/text_input.dart';
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
      children: [
        const ShowText(
          text: 'Max price',
          backgroundColor: Colors.transparent,
        ),
        Slider(
          value: priceValue,
          max: 100,
          min: 0,
          divisions: 100 * 2,
          label: priceValue == 0 ? 'No filter': priceValue.toStringAsFixed(1),
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
        Row(
          children: [
            Expanded(
              child: TextInput(
                hintText: 'Add filter',
                textEditingController: otherActivity,
              ),
            ),
            const SizedBox(
              width: spaceBetweenWidgets,
            ),
            GestureDetector(
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
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50)),
                child: const Icon(
                  Icons.add,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
