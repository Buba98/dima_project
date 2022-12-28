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

          await tester.tap(find.byKey(const Key('sign_in_button')));

          await tester.pumpAndSettle();

          await tester.enterText(find.byKey(const Key('email_text_input')),
              testingAccount['email']!);

          await tester.pumpAndSettle();

          await tester.testTextInput.receiveAction(TextInputAction.done);

          await tester.pumpAndSettle();

          await tester.enterText(find.byKey(const Key('password_text_input')),
              testingAccount['password']!);

          await tester.pumpAndSettle();

          await tester.testTextInput.receiveAction(TextInputAction.done);

          await tester.pumpAndSettle();

          await tester.tap(find.byKey(const Key('sign_in_button')));

          await pumpUntilFound(
            tester,
            find.text('Search'),
          );

          expect(tester.tap(find.text('Search')), findsAtLeastNWidgets(1));
        },
      );
    },
  );
}
