import 'package:dima_project/custom_widgets/button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AnswersScreen extends StatelessWidget {
  final String path;
  final String text;

  const AnswersScreen.yes({super.key, required this.text})
      : path = 'assets/images/yes.png';

  const AnswersScreen.no({super.key, required this.text})
      : path = 'assets/images/no.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Image.asset(path),
          Button(onPressed: () => Navigator.pop(context), text: text)
        ],
      ),
    );
  }
}
