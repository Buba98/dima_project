import 'package:dima_project/constants.dart';
import 'package:dima_project/input/selection/selection.dart';
import 'package:dima_project/input/selection/selection_element.dart';
import 'package:dima_project/input/text_input.dart';
import 'package:flutter/material.dart';

class FilterView extends StatelessWidget {
  FilterView({
    super.key,
    required this.addOtherActivity,
    required this.activities,
    required this.onChangeActivity,
  });

  final TextEditingController otherActivity = TextEditingController();
  final Function(SelectionElement) addOtherActivity;
  final List<SelectionElement> activities;
  final Function(int change) onChangeActivity;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Selection(
          onChanged: onChangeActivity,
          elements: activities,
        ),
        const Spacer(),
        Row(
          children: [
            Expanded(
              child: TextInput(
                hintText: 'Add activity',
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
