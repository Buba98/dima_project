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
  });

  const TextInput.email({
    super.key,
    required this.textEditingController,
    bool? error,
    this.errorText,
    this.textFieldKey = const Key('email_text_input'),
  })  : hintText = 'Enter email',
        icon = Icons.email_outlined,
        obscureText = false,
        textInputType = TextInputType.text;

  const TextInput.password({
    super.key,
    required this.textEditingController,
    bool? error,
    this.errorText,
    this.textFieldKey = const Key('password_text_input'),
  })  : hintText = 'Enter password',
        icon = Icons.lock_outline,
        obscureText = true,
        textInputType = TextInputType.text;

  final TextEditingController textEditingController;
  final String? hintText;
  final IconData? icon;
  final bool obscureText;
  final String? errorText;
  final Key? textFieldKey;
  final TextInputType textInputType;

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
          keyboardType: textInputType,
          key: textFieldKey,
          controller: textEditingController,
          decoration: InputDecoration(
            errorText: errorText,
            border: const UnderlineInputBorder(),
            hintText: hintText,
            icon: icon != null ? Icon(icon) : null,
          ),
          obscureText: obscureText,
        ),
      ),
    );
  }
}
