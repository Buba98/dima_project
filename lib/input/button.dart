import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  const Button({
    super.key,
    required Function() onPressed,
    required this.text,
    this.primary = true,
    this.attention = false,
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
  final bool attention;

  @override
  Widget build(BuildContext context) {
    if (primary) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          minimumSize: Size(width ?? double.infinity, 68),
          backgroundColor: attention
              ? Theme.of(context).errorColor
              : Theme.of(context).primaryColor,
        ),
        onPressed: onPressed,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (icon != null)
              Align(
                alignment: Alignment.centerLeft,
                child: Icon(
                  icon,
                ),
              ),
            Text(
              text,
              textAlign: TextAlign.center,
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
          foregroundColor: attention
              ? Theme.of(context).errorColor
              : Theme.of(context).primaryColor,
          side: BorderSide(
            color: attention
                ? Theme.of(context).errorColor
                : Theme.of(context).primaryColor,
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
