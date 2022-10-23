import 'package:flutter/material.dart';

class InlineSelection extends StatelessWidget {
  const InlineSelection({
    super.key,
    required this.value,
    required this.first,
    required this.second,
    this.onChanged,
    this.firstLeadingIcon,
    this.secondLeadingIcon,
  });

  final bool value;
  final String first;
  final String second;
  final Function(bool)? onChanged;
  final IconData? firstLeadingIcon;
  final IconData? secondLeadingIcon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              if (onChanged == null) return;
              onChanged!(true);
            },
            child: Container(
              alignment: Alignment.center,
              height: 68,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(20),
                ),
                color: value ? Colors.black26 : Colors.black12,
              ),
              child: Row(
                children: [
                  if (firstLeadingIcon != null)
                    Icon(
                      firstLeadingIcon,
                    ),
                  if (firstLeadingIcon != null)
                    const SizedBox(
                      width: 12,
                    ),
                  Expanded(
                    child: Text(
                      first,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              if (onChanged == null) return;
              onChanged!(false);
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              alignment: Alignment.center,
              height: 68,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(20),
                ),
                color: value ? Colors.black12 : Colors.black26,
              ),
              child: Row(
                children: [
                  if (secondLeadingIcon != null)
                    Icon(
                      secondLeadingIcon,
                    ),
                  if (secondLeadingIcon != null)
                    const SizedBox(
                      width: 12,
                    ),
                  Expanded(
                    child: Text(
                      second,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
