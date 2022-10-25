import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  const Button({
    super.key,
    required Function() onPressed,
    required this.text,
    this.primary = true,
    this.width,
    this.icon,
    this.disabled = false,
  }) : onPressed = disabled ? null : onPressed;

  final Function()? onPressed;
  final String text;
  final bool primary;
  final double? width;
  final IconData? icon;
  final bool disabled;

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
        child: Row(
          children: [
            if (icon != null)
              Icon(
                icon,
              ),
            if (icon != null)
              const SizedBox(
                width: 12,
              ),
            Expanded(
              child: Text(
                text,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
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
        child: Row(
          children: [
            if (icon != null)
              Icon(
                icon,
              ),
            if (icon != null)
              const SizedBox(
                width: 12,
              ),
            Expanded(
              child: Text(
                text,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );
    }
  }
}
