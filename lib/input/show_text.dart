import 'package:flutter/material.dart';

class ShowText extends StatelessWidget {
  const ShowText({
    super.key,
    required this.text,
    this.title,
    this.onPressed,
    this.trailerIcon,
    this.leadingIcon,
    this.backgroundColor = Colors.black26,
    this.centerText = false,
    this.wight,
  });

  final String text;
  final String? title;
  final Function()? onPressed;
  final IconData? trailerIcon;
  final IconData? leadingIcon;
  final Color backgroundColor;
  final bool centerText;
  final double? wight;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        alignment: Alignment.centerLeft,
        height: 68,
        width: wight,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
          color: backgroundColor,
        ),
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            if (leadingIcon != null)
              Icon(
                leadingIcon,
              ),
            if (leadingIcon != null)
              const SizedBox(
                width: 12,
              ),
            Column(
              crossAxisAlignment: centerText
                  ? CrossAxisAlignment.center
                  : CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (title != null)
                  Text(
                    title!,
                    style: const TextStyle(color: Colors.black45),
                  ),
                Text(
                  text,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Spacer(),
            if (trailerIcon != null)
              const SizedBox(
                width: 12,
              ),
            if (trailerIcon != null)
              Icon(
                trailerIcon,
              ),
          ],
        ),
      ),
    );
  }
}
