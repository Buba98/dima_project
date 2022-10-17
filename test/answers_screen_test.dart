import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dima_project/answers/answers_screen.dart';

void main() {
  testWidgets('Screens correctly work', (widgetTester) async {
    await widgetTester.pumpWidget(const MaterialApp(home: AnswersScreen.yes(text: "test yes")));
    await widgetTester.pumpWidget(const MaterialApp(home: AnswersScreen.no(text: "test no")));
  });
}
