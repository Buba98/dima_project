import 'dart:async';

import 'package:dima_project/main.dart' as app;
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group(
    'offer test',
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

          await tester.enterText(emailTextInput, 'nv.fg.dima@gmail.com');

          await tester.enterText(passwordTextInput, 'strongPassword666');

          await tester.tap(find.byKey(const Key('sign_in_button')));

          bool timerDone = false;
          Timer(const Duration(seconds: 5), () => timerDone = true);
          while (timerDone != true) {
            await tester.pump();
          }

          await tester.pumpAndSettle();

          await tester.tap(find.byKey(const Key('add_menu')));

          await tester.pumpAndSettle();

          await tester.tap(find.byKey(const Key('day_picker_button')));

          await tester.pumpAndSettle();

          await tester.tap(find.text('OK'));

          await tester.pumpAndSettle();

          await tester.tap(find.byKey(const Key('time_picker_button')));

          await tester.pumpAndSettle();

          await tester.tap(find.text('PM'));

          await tester.pumpAndSettle();

          var center = tester.getCenter(
              find.byKey(const ValueKey<String>('time-picker-dial')));

          await tester.tapAt(Offset(center.dx - .1, center.dy));

          await tester.pumpAndSettle();

          await tester.tap(find.text('OK'));

          await tester.pumpAndSettle();

          await tester.tap(find.byKey(const Key('duration_picker_button')));

          await tester.pumpAndSettle();

          await tester.tap(find.text('OK'));

          await tester.pumpAndSettle();

          await tester.enterText(
            find.byKey(const Key('price_text_input')),
            '1',
          );

          await tester.tap(find.text('Next'));

          await tester.pumpAndSettle();

          await tester.tap(find.text('park'));

          await tester.pumpAndSettle();

          await tester.tap(find.text('Next'));

          await tester.pumpAndSettle();

          await tester.tap(find.byKey(
            const Key('position_picker_map'),
          ));

          await tester.pumpAndSettle();

          timerDone = false;
          Timer(const Duration(seconds: 2), () => timerDone = true);
          while (timerDone != true) {
            await tester.pump();
          }

          await tester.tap(find.text('Complete'));

          await tester.pumpAndSettle();

          timerDone = false;
          Timer(const Duration(seconds: 2), () => timerDone = true);
          while (timerDone != true) {
            await tester.pump();
          }

          await tester.pumpAndSettle();

          await tester.tap(find.byKey(const Key('search_menu')));

          await tester.pumpAndSettle();
        },
      );
    },
  );
}
