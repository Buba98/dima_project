import 'package:dima_project/input/show_text.dart';
import 'package:dima_project/utils/utils.dart';
import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';

class DurationPicker extends StatelessWidget {
  const DurationPicker({
    super.key,
    required this.onChangeDuration,
    required this.duration,
    this.error = false,
  });

  final Duration? duration;
  final Function(Duration) onChangeDuration;
  final bool error;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ShowText(
            backgroundColor:
                error ? Colors.red.withOpacity(.26) : Colors.black26,
            onPressed: () async {
              final Duration? picked = await showDurationPicker(
                context: context,
                initialTime: const Duration(minutes: 30),
                baseUnit: BaseUnit.minute,
              );
              if (picked != null) {
                onChangeDuration(picked);
              }
            },
            text:
                duration != null ? printDuration(duration!) : 'Select duration',
            leadingIcon: Icons.timer,
            title: 'Duration',
          ),
        ),
      ],
    );
  }
}
