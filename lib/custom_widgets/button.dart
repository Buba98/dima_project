import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  const Button({
    super.key,
    required this.onPressed,
    required this.text,
    this.primary = true,
  });

  final Function() onPressed;
  final String text;
  final bool primary;

  @override
  Widget build(BuildContext context) {
    if (primary) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
          minimumSize: const Size.fromHeight(50),
        ),
        onPressed: onPressed,
        child: Text(text),
      );
    } else {
      return OutlinedButton(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32.0),
          ),
        ),
        onPressed: onPressed,
        child: Text(text),
      );
    }
  }
}
