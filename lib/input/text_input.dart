import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {
  const TextInput({
    super.key,
    required this.textEditingController,
    this.hintText,
    this.icon,
    this.obscureText = false,
    this.errorText,
  });

  const TextInput.email({
    super.key,
    required this.textEditingController,
    bool? error,
  })  : hintText = 'Enter email',
        icon = Icons.email_outlined,
        obscureText = false,
        errorText = (error ?? false) ? 'Wrong password' : null;

  const TextInput.password({
    super.key,
    required this.textEditingController,
    bool? error,
  })  : hintText = 'Enter password',
        icon = Icons.lock_outline,
        obscureText = true,
        errorText = (error ?? false) ? 'Wrong password' : null;

  final TextEditingController textEditingController;
  final String? hintText;
  final IconData? icon;
  final bool obscureText;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
        color: Colors.black26,
      ),
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: textEditingController,
        decoration: InputDecoration(
          errorText: errorText,
          border: const UnderlineInputBorder(),
          hintText: hintText,
          icon: icon != null ? Icon(icon) : null,
        ),
        obscureText: obscureText,
      ),
    );
  }
}
