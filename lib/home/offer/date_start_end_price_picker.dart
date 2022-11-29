import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import '../../input/button.dart';
import '../../input/text_input.dart';
import 'date_picker.dart';

class DateStartEndPricePicker extends StatefulWidget {
  const DateStartEndPricePicker({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.price,
    required this.onNext,
  });

  final DateTime? startDate;
  final DateTime? endDate;
  final Function(DateTime, DateTime, double) onNext;
  final double? price;

  @override
  State<DateStartEndPricePicker> createState() =>
      _DateStartEndPricePickerState();
}

class _DateStartEndPricePickerState extends State<DateStartEndPricePicker> {
  bool startDateError = false;
  bool endDateError = false;
  bool priceError = false;

  DateTime? startDate;
  DateTime? endDate;
  late TextEditingController priceEditingController;

  @override
  void initState() {
    startDate = widget.startDate;
    endDate = widget.endDate;
    priceEditingController = TextEditingController(
      text: widget.price?.toString(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        DatePicker(
          error: startDateError,
          startDate: DateTime.now(),
          date: startDate,
          onChangeDate: (DateTime dataTime) {
            setState(() {
              startDateError = false;
              startDate = dataTime;
            });
          },
        ),
        SizedBox(
          height: spaceBetweenWidgets,
        ),
        DatePicker(
          error: endDateError,
          date: endDate,
          startDate: startDate,
          onChangeDate: (DateTime dataTime) {
            setState(() {
              endDateError = false;
              endDate = dataTime;
            });
          },
        ),
        SizedBox(
          height: spaceBetweenWidgets,
        ),
        TextInput(
          errorText: priceError ? 'Insert valid price' : null,
          textInputType: TextInputType.number,
          textEditingController: priceEditingController,
          icon: Icons.attach_money,
        ),
        const Spacer(),
        Button(
          onPressed: () {
            if (startDate == null || startDate!.isBefore(DateTime.now())) {
              setState(() {
                startDateError = true;
              });
              return;
            }

            if (endDate == null || endDate!.isBefore(DateTime.now())) {
              setState(() {
                endDateError = true;
              });
              return;
            }

            if (priceEditingController.text.isEmpty ||
                double.tryParse(priceEditingController.text) == null ||
                double.parse(priceEditingController.text) <= 0) {
              setState(() {
                priceError = true;
              });
              return;
            }
            widget.onNext(startDate!, endDate!,
                double.parse(priceEditingController.text));
          },
          text: 'Next',
        ),
      ],
    );
  }
}
