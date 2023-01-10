import 'package:dima_project/constants.dart';
import 'package:dima_project/generated/l10n.dart';
import 'package:dima_project/input/button.dart';
import 'package:dima_project/input/selection/selection.dart';
import 'package:dima_project/input/selection/selection_element.dart';
import 'package:dima_project/input/text_input_button.dart';
import 'package:dima_project/utils/utils.dart';
import 'package:flutter/material.dart';

class ActivitiesPicker extends StatefulWidget {
  const ActivitiesPicker({
    super.key,
    required this.activities,
    required this.onNext,
    required this.onBack,
  });

  final List<SelectionElement<String>>? activities;
  final Function(List<SelectionElement<String>>) onNext;
  final Function(List<SelectionElement<String>>) onBack;

  @override
  State<ActivitiesPicker> createState() => _ActivitiesPickerState();
}

class _ActivitiesPickerState extends State<ActivitiesPicker> {
  List<SelectionElement<String>>? activities;
  final TextEditingController otherOption = TextEditingController();
  bool error = false;

  void onAddActivity() {
    if (otherOption.text.isEmpty) {
      return;
    }

    for (SelectionElement activity in activities!) {
      if (activity.name == otherOption.text) {
        otherOption.clear();
        return;
      }
    }

    setState(() {
      activities = [
        ...activities!,
        SelectionElement<String>(
          name: otherOption.text,
          selected: true,
          element: otherOption.text,
        )
      ];
      error = false;
    });

    otherOption.clear();
  }

  @override
  Widget build(BuildContext context) {
    activities ??= widget.activities ??
        List.from(
          defaultActivities(context).map(
            (Map<String, String> e) => SelectionElement<String>(
              name: e['name']!,
              selected: false,
              element: e['value']!,
            ),
          ),
        );

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Selection(
              spacing: spaceBetweenWidgets,
              direction: Axis.horizontal,
              elements: activities!,
              onChanged: (int change) {
                setState(() {
                  error = false;
                  activities![change].selected = !activities![change].selected;
                });
              },
            ),
          ),
        ),
        const SizedBox(
          height: spaceBetweenWidgets,
        ),
        TextInputButton(
          errorText: error ? S.of(context).selectAtLeastOneActivity : null,
          textIcon: Icons.add,
          textEditingController: otherOption,
          onTap: onAddActivity,
          hintText: S.of(context).addActivity,
          iconButton: Icons.add,
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
                  if (activities!
                      .every((element) => element.selected == false)) {
                    setState(() {
                      error = true;
                    });
                    return;
                  }

                  widget.onBack(activities!);
                },
                text: S.of(context).back,
              ),
            ),
            const SizedBox(
              width: spaceBetweenWidgets,
            ),
            Expanded(
              child: Button(
                onPressed: () {
                  if (activities!
                      .every((element) => element.selected == false)) {
                    setState(() {
                      error = true;
                    });
                    return;
                  }

                  widget.onNext(activities!);
                },
                text: S.of(context).next,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
