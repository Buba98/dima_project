import 'package:dima_project/constants.dart';
import 'package:dima_project/generated/l10n.dart';
import 'package:dima_project/home/offer/date_picker.dart';
import 'package:dima_project/home/offer/duration_picker.dart';
import 'package:dima_project/input/button.dart';
import 'package:dima_project/input/text_input.dart';
import 'package:flutter/material.dart';

class StartDateDurationPricePicker extends StatefulWidget {
  const StartDateDurationPricePicker({
    super.key,
    required this.startDate,
    required this.duration,
    required this.price,
    required this.onNext,
  });

  final DateTime? startDate;
  final Duration? duration;
  final Function(DateTime, Duration, double) onNext;
  final double? price;

  @override
  State<StartDateDurationPricePicker> createState() =>
      _StartDateDurationPricePickerState();
}

class _StartDateDurationPricePickerState
    extends State<StartDateDurationPricePicker> {
  bool startDateError = false;
  bool durationError = false;
  bool priceError = false;

  DateTime? startDate;
  Duration? duration;
  late TextEditingController priceEditingController;

  @override
  void initState() {
    startDate = widget.startDate;
    duration = widget.duration;
    priceEditingController = TextEditingController(
      text: widget.price?.toString(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        shrinkWrap: true,
        children: [
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
          const SizedBox(
            height: spaceBetweenWidgets,
          ),
          DurationPicker(
            onChangeDuration: (Duration duration) {
              setState(() {
                durationError = false;
                this.duration = duration;
              });
            },
            duration: duration,
            error: durationError,
          ),
          const SizedBox(
            height: spaceBetweenWidgets,
          ),
          TextInput(
            key: const Key('price_text_input'),
            hintText: S.of(context).selectPrice,
            errorText: priceError ? S.of(context).insertValidPrice : null,
            textInputType: TextInputType.number,
            textEditingController: priceEditingController,
            icon: Icons.attach_money,
          ),
          const SizedBox(
            height: spaceBetweenWidgets,
          ),
          Button(
            onPressed: () {
              if (startDate == null || startDate!.isBefore(DateTime.now())) {
                setState(() {
                  startDateError = true;
                });
                return;
              }

              if (duration == null ||
                  duration!.compareTo(const Duration(seconds: 0)) < 0) {
                setState(() {
                  durationError = true;
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
              widget.onNext(startDate!, duration!,
                  double.parse(priceEditingController.text));
            },
            text: S.of(context).next,
          ),
        ],
      ),
    );
  }
}
