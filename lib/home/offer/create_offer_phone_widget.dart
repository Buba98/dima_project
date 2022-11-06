import 'package:dima_project/input/selection/selection.dart';
import 'package:dima_project/input/text_input.dart';
import 'package:intl/intl.dart';
import 'package:dima_project/input/button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../input/selection/selection_element.dart';

class CreateOfferPhoneWidget extends StatefulWidget {
  const CreateOfferPhoneWidget({super.key});

  @override
  _CreateOfferPhoneWidgetState createState() => _CreateOfferPhoneWidgetState();
}

class _CreateOfferPhoneWidgetState extends State<CreateOfferPhoneWidget> {
  double? price;
  final List<SelectionElement> activities = [
    SelectionElement(name: 'walk', selected: true),
    SelectionElement(name: 'example1', selected: false),
    SelectionElement(name: 'example2', selected: false),
    SelectionElement(name: 'other', selected: false),
  ];

  bool _isOtherActivitiesSelected = false;
  bool _isOtherOptionsVisible = false;

  DateTime selectedDate = DateTime.now();
  String selectedDateString = 'no selected date';

  TimeOfDay selectedStartingTime = TimeOfDay.now();
  String selectedStartingTimeString = 'no starting time';

  bool _isEndingTimeButtonDisabled = true;
  TimeOfDay selectedEndingTime = TimeOfDay(
      hour: TimeOfDay.now().hour, minute: TimeOfDay.now().minute + 30);
  String selectedEndingTimeString = 'no ending time';

  // List<String> maxDogsAllowedList = ['1', '2', '3', '4', '5', 'Any'];
  // int maxDogsAllowed = -1;
  // String maxDogsAllowedHint = '';

  bool _isNotPast({required DateTime selectedDate, TimeOfDay? selectedTime}) {
    DateTime now = DateTime.now();
    if (selectedTime == null) {
      DateTime selected =
          DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
      return (selected.year == now.year &&
              selected.month == now.month &&
              selected.day == now.day) ||
          selected.isAfter(now);
    } else {
      DateTime selected = DateTime(selectedDate.year, selectedDate.month,
          selectedDate.day, selectedTime.hour, selectedTime.minute);
      return (selected.year == now.year &&
              selected.month == now.month &&
              selected.day == now.day &&
              selected.hour == now.hour &&
              selected.minute == now.minute) ||
          selected.isAfter(now);
    }
  }

  Future<void> _selectDate({required BuildContext context}) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null &&
        _isNotPast(
          selectedDate: picked,
        )) {
      setState(() {
        selectedDate = picked;
        DateTime now = DateTime.now();
        if (DateTime(selectedDate.year, selectedDate.month, selectedDate.day) ==
            DateTime(now.year, now.month, now.day)) {
          selectedDateString = 'Today';
        } else if (DateTime(
                selectedDate.year, selectedDate.month, selectedDate.day) ==
            DateTime(now.year, now.month, now.day + 1)) {
          selectedDateString = 'Tomorrow';
        } else {
          selectedDateString = DateFormat('E d MMM')
              .format(selectedDate); //TODO fix search result widget format
        }
      });
    }
    selectedStartingTime = TimeOfDay.now();
    selectedStartingTimeString = 'no starting time';
    selectedEndingTime = TimeOfDay(
        hour: TimeOfDay.now().hour + 1, minute: TimeOfDay.now().minute);
    selectedEndingTimeString = 'no ending time';
    _isEndingTimeButtonDisabled = true;
  }

  Future<void> _selectTime(
      {required BuildContext context, required bool isStart}) async {
    final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: isStart
            ? TimeOfDay.now()
            : TimeOfDay.fromDateTime(DateTime(
                    DateTime.now().year,
                    DateTime.now().month,
                    DateTime.now().day,
                    selectedStartingTime.hour,
                    selectedStartingTime.minute)
                .add(const Duration(minutes: 30))),
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child!,
          );
        });
    if (isStart) {
      if (picked != null &&
          _isNotPast(selectedDate: selectedDate, selectedTime: picked)) {
        setState(() {
          selectedStartingTime = picked;
          selectedStartingTimeString = const DefaultMaterialLocalizations()
              .formatTimeOfDay(selectedStartingTime,
                  alwaysUse24HourFormat: true);
        });
        _isEndingTimeButtonDisabled = false;
      }
    } else {
      if (picked != null &&
          ((picked.hour == selectedStartingTime.hour &&
                  picked.minute > selectedStartingTime.minute) ||
              (picked.hour > selectedStartingTime.hour))) {
        setState(() {
          selectedEndingTime = picked;
          selectedEndingTimeString = const DefaultMaterialLocalizations()
              .formatTimeOfDay(selectedEndingTime, alwaysUse24HourFormat: true);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      width: MediaQuery.of(context).size.width * 0.95,
      child: ListView(
        children: [
          Button(
            onPressed: () => _selectDate(context: context),
            text: ' $selectedDateString',
            icon: Icons.calendar_month_outlined,
          ),
          const SizedBox(
            height: 5,
          ),
          Button(
            onPressed: () => _selectTime(context: context, isStart: true),
            text: 'Start: $selectedStartingTimeString',
            icon: Icons.timer_outlined,
          ),
          const SizedBox(
            height: 5,
          ),
          ElevatedButton(
            //TODO change UI
            onPressed: _isEndingTimeButtonDisabled
                ? null
                : () => _selectTime(context: context, isStart: false),
            child: Row(
              children: [
                Spacer(),
                Icon(Icons.sports_score_outlined),
                Text(' End: $selectedEndingTimeString'),
                Spacer(),
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          ElevatedButton(
              onPressed: () => {}, child: Text('location placeholder')),
          const SizedBox(
            height: 15,
          ),
          Row(
            children: const [
              Spacer(),
              Text('Price '),
              SizedBox(
                width: 100,
                child: TextField(
                  keyboardType: TextInputType.number,
                ),
              ),
              Text('€/h'),
              Spacer(),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Selection(
            elements: activities,
            onChanged: (value) {
              setState(() {
                activities[value].selected = !activities[value].selected;
                for (int i = 0; i < activities.length; i++) {
                }
                if (value == activities.length - 1) {
                  _isOtherActivitiesSelected = !_isOtherActivitiesSelected;
                }
              });
            },
          ),
          Visibility(
            visible: _isOtherActivitiesSelected,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Column(children: [
                const SizedBox(
                  height: 15,
                ),
                TextInput(
                    textEditingController: TextEditingController(text: '')),
              ]),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Center(
            child: Button(
                onPressed: () {
                  setState(() {
                    _isOtherOptionsVisible = !_isOtherOptionsVisible;
                  });
                },
                text: 'Other options'),
          ),
          //TODO make it interactable to open other options to be filed
          // Visibility(
          //   child: Column(
          //     children: [
          //       Row(
          //         children: [
          //           Text('#max'),
          //           DropdownButton(
          //               hint: Text(maxDogsAllowedHint),
          //               items: maxDogsAllowedList
          //                   .map<DropdownMenuItem<String>>((String value) {
          //                 return DropdownMenuItem<String>(
          //                   value: value,
          //                   child: Text(value),
          //                 );
          //               }).toList(),
          //               onChanged: (String? value) {
          //                 setState(() {
          //                   maxDogsAllowed = 3;
          //                   maxDogsAllowedHint = value!;
          //                 });
          //               }),
          //         ],
          //       )
          //     ],
          //   ),
          // )
        ],
      ),
    );
  }
}
