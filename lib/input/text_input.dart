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
  });

  const TextInput.email({
    super.key,
    required this.textEditingController,
    bool? error,
    this.textFieldKey = const Key('email_text_input'),
  })  : hintText = 'Enter email',
        icon = Icons.email_outlined,
        obscureText = false,
        errorText = (error ?? false) ? 'Wrong password' : null;

  const TextInput.password({
    super.key,
    required this.textEditingController,
    bool? error,
    this.textFieldKey = const Key('password_text_input'),
  })  : hintText = 'Enter password',
        icon = Icons.lock_outline,
        obscureText = true,
        errorText = (error ?? false) ? 'Wrong password' : null;

  final TextEditingController textEditingController;
  final String? hintText;
  final IconData? icon;
  final bool obscureText;
  final String? errorText;
  final Key? textFieldKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
        color: Colors.black26,
      ),
      padding: const EdgeInsets.all(10),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 48),
        child: TextField(
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
