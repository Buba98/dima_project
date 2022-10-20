import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  const Button({
    super.key,
    required this.onPressed,
    required this.text,
    this.primary = true,
    this.width,
  });

  final Function() onPressed;
  final String text;
  final bool primary;
  final double? width;

  @override
  Widget build(BuildContext context) {
    if (primary) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          minimumSize: Size(width ?? double.infinity, 68),
        ),
        onPressed: onPressed,
        child: Text(text),
      );
    } else {
      return OutlinedButton(
        style: OutlinedButton.styleFrom(
          minimumSize: Size(width ?? double.infinity, 68),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        onPressed: onPressed,
        child: Text(text),
      );
    }
  }
}
