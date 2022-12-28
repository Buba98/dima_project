import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {
  const TextInput({
    super.key,
    required this.textEditingController,
    this.hintText,
    this.icon,
    this.obscureText = false,
    this.errorText,
    this.textFieldKey,
    this.textInputType = TextInputType.text,
    this.maxLines,
  });

  const TextInput.email({
    super.key,
    required this.textEditingController,
    this.textFieldKey = const Key('email_text_input'),
    this.errorText,
  })  : hintText = 'Enter email',
        icon = Icons.email_outlined,
        obscureText = false,
        textInputType = TextInputType.text,
        maxLines = 1;

  const TextInput.password({
    super.key,
    required this.textEditingController,
    this.textFieldKey = const Key('password_text_input'),
    this.errorText,
  })  : hintText = 'Enter password',
        icon = Icons.lock_outline,
        obscureText = true,
        textInputType = TextInputType.text,
        maxLines = 1;

  final TextEditingController textEditingController;
  final String? hintText;
  final IconData? icon;
  final bool obscureText;
  final String? errorText;
  final Key? textFieldKey;
  final TextInputType? textInputType;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
        color: errorText != null ? Colors.red.withOpacity(.26) : Colors.black26,
      ),
      padding: const EdgeInsets.all(10),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 48),
        child: TextField(
          maxLines: maxLines,
          minLines: 1,
          keyboardType: textInputType,
          key: textFieldKey,
          controller: textEditingController,
          decoration: InputDecoration(
            errorText: errorText,
            border: InputBorder.none,
            hintText: hintText,
            icon: icon != null ? Icon(icon) : null,
          ),
          obscureText: obscureText,
        ),
      ),
    );
  }
}
