import 'package:flutter/material.dart';

class InlineSelection extends StatefulWidget {
  const InlineSelection({
    super.key,
    this.initialValue = true,
    required this.first,
    required this.second,
    this.onChanged,
    this.firstLeadingIcon,
    this.secondLeadingIcon,
  });

  final bool initialValue;
  final String first;
  final String second;
  final Function(bool)? onChanged;
  final IconData? firstLeadingIcon;
  final IconData? secondLeadingIcon;

  @override
  State<StatefulWidget> createState() => _InlineSelectionState();
}

class _InlineSelectionState extends State<InlineSelection> {
  late bool value;

  @override
  void initState() {
    value = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() => value = true);
              if (widget.onChanged == null) return;
              widget.onChanged!(true);
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
                  if (widget.firstLeadingIcon != null)
                    Icon(
                      widget.firstLeadingIcon,
                    ),
                  if (widget.firstLeadingIcon != null)
                    const SizedBox(
                      width: 12,
                    ),
                  Expanded(
                    child: Text(
                      widget.first,
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
              setState(() => value = false);
              if (widget.onChanged == null) return;
              widget.onChanged!(false);
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
                  if (widget.secondLeadingIcon != null)
                    Icon(
                      widget.secondLeadingIcon,
                    ),
                  if (widget.secondLeadingIcon != null)
                    const SizedBox(
                      width: 12,
                    ),
                  Expanded(
                    child: Text(
                      widget.second,
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
