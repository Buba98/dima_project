import 'package:intl/intl.dart';
import 'package:dima_project/custom_widgets/button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreateOfferWidget extends StatefulWidget {
  const CreateOfferWidget({super.key});

  @override
  _CreateOfferWidgetState createState() => _CreateOfferWidgetState();
}

class _CreateOfferWidgetState extends State<CreateOfferWidget> {
  double? price;
  final Map<String, bool?> activities = {
    'walk': true,
    'example1': false,
    'example2': false,
    //'example3': false,
    'other': false,
  };
  bool visibleCalendar = false;
  bool visibleStartTime = false;
  bool visibleEndTime = false;

  DateTime selectedDate = DateTime.now();
  String selectedDateString = 'no selected date';

  TimeOfDay selectedStartingTime = TimeOfDay.now();
  String selectedStartingTimeString = 'no starting time';

  bool _isEndingTimeButtonDisabled = true;
  TimeOfDay selectedEndingTime =
      TimeOfDay(hour: TimeOfDay.now().hour + 1, minute: TimeOfDay.now().minute);
  String selectedEndingTimeString = 'no ending time';

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

  //TODO delete
  Widget _tmpSpacer(color) {
    return Container(
      height: 20,
      decoration: BoxDecoration(
        color: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      width: MediaQuery.of(context).size.width * 0.95,
      child: ListView(
        children: [
          ElevatedButton(
            onPressed: () => _selectDate(context: context),
            child: Row(
              children: [
                Spacer(),
                Icon(Icons.calendar_month_outlined),
                Text(' $selectedDateString'),
                Spacer(),
                //TODO maybe use RichText for readability
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          ElevatedButton(
            onPressed: () => _selectTime(context: context, isStart: true),
            child: Row(
              children: [
                Spacer(),
                Icon(Icons.timer_outlined),
                Text(' Start: $selectedStartingTimeString'),
                Spacer(),
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          ElevatedButton(
            onPressed: _isEndingTimeButtonDisabled ? null : () => _selectTime(context: context, isStart: false),
            child: Row(
              children: [
                Spacer(),
                Icon(Icons.sports_score_outlined),
                Text(' End: $selectedEndingTimeString'),
                Spacer(),
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          ElevatedButton(
              onPressed: () => {}, child: Text('location placeholder')),
          SizedBox(
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
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xFF287762)),
            ),
            child: Column(
              children: [
                Text('Activities'),
                Container(
                  height: activities.keys.length * 35 + 15,
                  child: ListView(
                    children: activities.keys.map((String key) {
                      return SizedBox(
                        height: 35,
                        // height: max(min(MediaQuery.of(context).size.height * 0.8,40),30), //TODO better way? useful?
                        child: CheckboxListTile(
                          title: Text(key),
                          value: activities[key],
                          onChanged: (bool? value) {
                            setState(() {
                              activities[key] = value;
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
                //     //TODO make a appear a TextField to describe 'other' activities
              ],
            ),
          ),
          const Center(
            child: Text('Other options'),
          ),
          //TODO make it interactable to open other options to be filed
        ],
      ),
    );
  }
}
