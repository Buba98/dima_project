import 'package:flutter/material.dart';

class SwitchInput extends StatefulWidget {
  const SwitchInput({
    super.key,
    this.initialValue = true,
    this.onChanged,
    required this.text,
    required this.leadingIcon,
  });

  final bool initialValue;
  final Function(bool)? onChanged;
  final String text;
  final IconData? leadingIcon;

  @override
  State<StatefulWidget> createState() => _SwitchInputState();
}

class _SwitchInputState extends State<SwitchInput> {
  late bool value;

  @override
  void initState() {
    value = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => value = !value),
      child: Container(
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
            if (widget.leadingIcon != null)
              Icon(
                widget.leadingIcon,
              ),
            if (widget.leadingIcon != null)
              const SizedBox(
                width: 12,
              ),
            Text(
              widget.text,
            ),
            const Spacer(),
            Switch(
              value: value,
              onChanged: (bool newValue) {
                setState(() => value = newValue);
                if (widget.onChanged == null) return;
                widget.onChanged!(newValue);
              },
            ),
          ],
        ),
      ),
    );
  }
}
