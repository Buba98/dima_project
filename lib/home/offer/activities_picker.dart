import 'package:dima_project/constants.dart';
import 'package:dima_project/input/button.dart';
import 'package:dima_project/input/selection/selection.dart';
import 'package:dima_project/input/selection/selection_element.dart';
import 'package:dima_project/input/text_input.dart';
import 'package:dima_project/utils/utils.dart';
import 'package:flutter/material.dart';

class ActivitiesPicker extends StatefulWidget {
  const ActivitiesPicker({
    super.key,
    required this.activities,
    required this.onNext,
    required this.onBack,
  });

  final List<SelectionElement>? activities;
  final Function(List<SelectionElement>) onNext;
  final Function(List<SelectionElement>) onBack;

  @override
  State<ActivitiesPicker> createState() => _ActivitiesPickerState();
}

class _ActivitiesPickerState extends State<ActivitiesPicker> {
  late List<SelectionElement> activities;
  final TextEditingController otherOption = TextEditingController();
  bool error = false;

  @override
  void initState() {
    activities = widget.activities ??
        List.from(
          defaultActivities.map(
            (e) => SelectionElement(name: e, selected: false),
          ),
        );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Selection(
              spacing: spaceBetweenWidgets,
              direction: Axis.horizontal,
              rows: isTablet(context) ? 4 : 2,
              elements: activities,
              onChanged: (int change) {
                setState(() {
                  error = false;
                  activities[change].selected = !activities[change].selected;
                });
              },
            ),
          ),
        ),
        const SizedBox(
          height: spaceBetweenWidgets,
        ),
        Row(
          children: [
            Expanded(
              child: TextInput(
                icon: Icons.add,
                textEditingController: otherOption,
                errorText: error ? 'Select at least one activity' : null,
              ),
            ),
            const SizedBox(
              width: spaceBetweenWidgets,
            ),
            GestureDetector(
              onTap: () {
                if (otherOption.text.isEmpty) {
                  return;
                }

                for (SelectionElement activity in activities) {
                  if (activity.name == otherOption.text) {
                    otherOption.clear();
                    return;
                  }
                }

                setState(() {
                  activities = [
                    ...activities,
                    SelectionElement(name: otherOption.text, selected: true)
                  ];
                  error = false;
                });

                otherOption.clear();
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
        const SizedBox(
          height: spaceBetweenWidgets,
        ),
        Row(
          children: [
            Expanded(
              child: Button(
                primary: false,
                onPressed: () {
                  if (activities
                      .every((element) => element.selected == false)) {
                    setState(() {
                      error = true;
                    });
                    return;
                  }

                  widget.onBack(activities);
                },
                text: 'Back',
              ),
            ),
            const SizedBox(
              width: spaceBetweenWidgets,
            ),
            Expanded(
              child: Button(
                onPressed: () {
                  if (activities
                      .every((element) => element.selected == false)) {
                    setState(() {
                      error = true;
                    });
                    return;
                  }

                  widget.onNext(activities);
                },
                text: 'Next',
              ),
            ),
          ],
        ),
      ],
    );
  }
}
