import 'dart:math';

import 'package:dima_project/main.dart' as app;
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group(
    'authentication test',
    () {
      testWidgets(
        'Sign in test',
        (WidgetTester tester) async {
          await app.main();
          await tester.pumpAndSettle();

          final signUpButton = find.byKey(const Key('sign_in_button'));

          expect(signUpButton, findsOneWidget);

          await tester.tap(signUpButton);

          await tester.pumpAndSettle();

          final emailTextInput = find.byKey(const Key('email_text_input'));
          final passwordTextInput =
              find.byKey(const Key('password_text_input'));

          expect(emailTextInput, findsOneWidget);

          await tester.enterText(emailTextInput, testingAccount['email']!);

          await tester.enterText(
              passwordTextInput, testingAccount['password']!);

          await tester.tap(find.byKey(const Key('sign_in_button')));

          await pumpUntilFound(
            tester,
            find.text('Search'),
          );
        },
      );
    },
  );
}
