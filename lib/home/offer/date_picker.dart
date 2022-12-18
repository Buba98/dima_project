import 'package:dima_project/constants.dart';
import 'package:dima_project/generated/l10n.dart';
import 'package:dima_project/input/show_text.dart';
import 'package:dima_project/utils/utils.dart';
import 'package:flutter/material.dart';

class DatePicker extends StatelessWidget {
  const DatePicker({
    super.key,
    required this.startDate,
    required this.onChangeDate,
    required this.date,
    this.error = false,
  });

  final DateTime? startDate;
  final DateTime? date;
  final Function(DateTime) onChangeDate;
  final bool error;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ShowText(
            key: const Key('day_picker_button'),
            backgroundColor:
                error ? Colors.red.withOpacity(.26) : Colors.black26,
            onPressed: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: date ?? DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(
                  const Duration(days: 365),
                ),
              );
              if (picked != null) {
                onChangeDate(
                  DateTime(
                    picked.year,
                    picked.month,
                    picked.day,
                    date != null ? date!.hour : 0,
                    date != null ? date!.minute : 0,
                  ),
                );
              }
            },
            text: date != null ? printDate(date!) : S.of(context).selectDate,
            leadingIcon: Icons.calendar_month_outlined,
            title: S.of(context).startDate,
          ),
        ),
        const SizedBox(
          width: spaceBetweenWidgets,
        ),
        Expanded(
          child: ShowText(
            key: const Key('time_picker_button'),
            backgroundColor:
                error ? Colors.red.withOpacity(.26) : Colors.black26,
            onPressed: () async {
              final TimeOfDay? picked = await showTimePicker(
                context: context,
                initialTime: date != null
                    ? TimeOfDay(hour: date!.hour, minute: date!.minute)
                    : TimeOfDay.now(),
              );

              if (picked != null) {
                onChangeDate(
                  DateTime(
                    date != null ? date!.year : DateTime.now().year,
                    date != null ? date!.month : DateTime.now().month,
                    date != null ? date!.day : DateTime.now().day,
                    picked.hour,
                    picked.minute,
                  ),
                );
              }
            },
            text: date != null ? printTime(date!) : S.of(context).selectTime,
            leadingIcon: Icons.access_time,
            title: S.of(context).startTime,
          ),
        ),
      ],
    );
  }
}
