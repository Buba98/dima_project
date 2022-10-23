import 'package:flutter/material.dart';

class ShowText extends StatelessWidget {
  const ShowText(
      {super.key,
      required this.text,
      required this.title,
      this.onPressed,
      this.trailerIcon,
      this.leadingIcon});

  final String text;
  final String title;
  final Function()? onPressed;
  final IconData? trailerIcon;
  final IconData? leadingIcon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        alignment: Alignment.centerLeft,
        height: 68,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
          color: Colors.black26,
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(color: Colors.black45),
                  ),
                  Text(
                    text,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
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
