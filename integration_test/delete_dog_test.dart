import 'dart:async';

import 'package:dima_project/main.dart' as app;
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'dart:math' as math;

import 'utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group(
    'dog test',
        () {
      testWidgets(
        'offer creation test',
            (WidgetTester tester) async {
          await app.main();
          await tester.pumpAndSettle();

          await tester.tap(find.byKey(const Key('sign_in_button')));

          await tester.pumpAndSettle();

          final emailTextInput = find.byKey(const Key('email_text_input'));
          final passwordTextInput =
          find.byKey(const Key('password_text_input'));

          expect(emailTextInput, findsOneWidget);

          await tester.enterText(emailTextInput, testingAccount['email']!);

          await tester.pumpAndSettle();

          await tester.testTextInput.receiveAction(TextInputAction.done);

          await tester.pumpAndSettle();

          await tester.enterText(
              passwordTextInput, testingAccount['password']!);

          await tester.pumpAndSettle();

          await tester.testTextInput.receiveAction(TextInputAction.done);

          await tester.pumpAndSettle();

          await tester.tap(find.byKey(const Key('sign_in_button')));

          bool timerDone = false;
          Timer(const Duration(seconds: 5), () => timerDone = true);
          while (timerDone != true) {
            await tester.pump();
          }

          await tester.pumpAndSettle();

          await tester.tap(find.byKey(const Key('profile_menu')));

          await tester.pumpAndSettle();

          await tester.tap(find.text('Add new dog'));

          await tester.pumpAndSettle();

          var name = 'Beautiful doggo${math.Random().nextDouble()}';

          await tester.enterText(
              find.byKey(const Key('dog_name_input')), name);

          await tester.pumpAndSettle();

          await tester.testTextInput.receiveAction(TextInputAction.done);

          await tester.pumpAndSettle();

          await tester.tap(find.text('Female'));

          await tester.pumpAndSettle();

          await tester.tap(find.text('Finalize'));

          await tester.pumpAndSettle();

          await pumpUntilFound(tester, find.text(name));

          timerDone = false;
          Timer(const Duration(seconds: 1), () => timerDone = true);
          while (timerDone != true) {
            await tester.pump();
          }

          await tester.tap(find.text(name));

          await tester.pumpAndSettle();

          await tester.tap(find.text('Delete dog'));

          await tester.pumpAndSettle();
        },
      );
    },
  );
}
