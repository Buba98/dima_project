import 'dart:math';

import 'package:dima_project/main.dart' as app;
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group(
    'authentication test',
    () {
      testWidgets(
        'Sign up test',
        (WidgetTester tester) async {
          app.main();
          await tester.pump(
            const Duration(seconds: 3),
          );
          await tester.pumpAndSettle();

          await tester.tap(
            find.text('Sign Up'),
          );

          await tester.pumpAndSettle(const Duration(seconds: 1));

          expect(
            find.text('Welcome'),
            findsOneWidget,
          );

          await tester.enterText(
            find.byKey(const Key('email_text_input')),
            'test${Random().nextDouble()}@gmail.com',
          );

          await tester.enterText(
            find.byKey(const Key('password_text_input')),
            'test1234',
          );

          await tester.tap(find.byKey(
            const Key('sign_up_button'),
          ));

          await Future<void>.delayed(const Duration(seconds: 3));

          await tester.pumpAndSettle();

          expect(
            find.text('Finalize'),
            findsOneWidget,
          );
        },
      );
    },
  );
}


