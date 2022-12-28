import 'dart:async';

import 'package:dima_project/main.dart' as app;
import 'package:dima_project/utils/utils.dart';
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

          await tester.pumpAndSettle();

          await tester.testTextInput.receiveAction(TextInputAction.done);

          await tester.pumpAndSettle();

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

          await pumpUntilFound(tester, find.byKey(const Key('orders_menu')));

          await tester.pumpAndSettle();

          await tester.tap(find.byKey(const Key('orders_menu')));

          await tester.pumpAndSettle();

          await pumpUntilFound(tester, find.text(printDate(DateTime.now())));

          await tester.tap(find.text(printDate(DateTime.now())));

          await tester.pumpAndSettle();

          await tester.dragUntilVisible(find.text("Delete offer"),
              find.byType(ListView), const Offset(0, 500) // delta to move
              );

          await tester.pumpAndSettle();

          await tester.tap(find.text("Delete offer"));

          expect(find.text(printDate(DateTime.now())), findsNothing);
        },
      );
    },
  );
}
