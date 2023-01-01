import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:math' as math;

Future<void> pumpUntilFound(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 10),
}) async {
  bool timerDone = false;
  final timer = Timer(timeout, () => timerDone = true);
  while (timerDone != true) {
    await tester.pump();

    final bool found = tester.any(finder);
    if (found) {
      timerDone = true;
    }
  }
  timer.cancel();
}

Future<void> pumpUntilNotFound(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 10),
}) async {
  bool timerDone = false;
  final timer = Timer(timeout, () => timerDone = true);
  while (timerDone != true) {
    await tester.pump();

    final bool found = tester.any(finder);
    if (!found) {
      timerDone = true;
    }
  }
  timer.cancel();
}

Future<void> waitForNSeconds(
  WidgetTester tester, {
  Duration timeout = const Duration(seconds: 3),
}) async {
  bool timerDone = false;
  final timer = Timer(timeout, () => timerDone = true);
  while (timerDone != true) {
    await tester.pump();
  }
  timer.cancel();
}

const Map<String, String> testingAccount = {
  'email': 'nv.fg.dima@gmail.com',
  'password': 'dan1el!!'
};

Future<void> loginSteps(
  WidgetTester tester,
) async {
  await tester.pumpAndSettle();

  await tester.tap(find.byKey(const Key('sign_in_button')));

  await tester.pumpAndSettle();

  await tester.enterText(
      find.byKey(const Key('email_text_input')), testingAccount['email']!);

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

  bool timerDone = false;
  Timer(const Duration(seconds: 5), () => timerDone = true);
  while (timerDone != true) {
    await tester.pump();
  }
}

Future<String> createDogSteps(WidgetTester tester) async {
  await tester.pumpAndSettle();

  await tester.tap(find.byKey(const Key('profile_menu')));

  await tester.pumpAndSettle();

  await tester.tap(find.text('Add new dog'));

  await tester.pumpAndSettle();

  final String name = 'Beautiful doggo${math.Random().nextDouble()}';

  await tester.enterText(find.byKey(const Key('dog_name_input')), name);

  await tester.pumpAndSettle();

  await tester.testTextInput.receiveAction(TextInputAction.done);

  await tester.pumpAndSettle();

  await tester.tap(find.text('Female'));

  await tester.pumpAndSettle();

  await tester.tap(find.text('Finalize'));

  await tester.pumpAndSettle();

  await pumpUntilFound(tester, find.text(name));

  return name;
}

Future<int> createOfferSteps(WidgetTester tester) async {
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

  var center =
      tester.getCenter(find.byKey(const ValueKey<String>('time-picker-dial')));

  await tester.tapAt(Offset(center.dx - .1, center.dy));

  await tester.pumpAndSettle();

  await tester.tap(find.text('OK'));

  await tester.pumpAndSettle();

  await tester.tap(find.byKey(const Key('duration_picker_button')));

  await tester.pumpAndSettle();

  await tester.tap(find.text('OK'));

  await tester.pumpAndSettle();

  final int price = math.Random().nextInt(100);

  await tester.enterText(
    find.byKey(const Key('price_text_input')),
    '$price',
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

  bool timerDone = false;
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

  await pumpUntilFound(tester, find.text('\$${price.toStringAsFixed(2)}'));

  return price;
}

Future<String> createOrderSteps(WidgetTester tester) async {
  const String name = 'Beautiful Guy';

  await tester.pumpAndSettle();

  await tester.tap(find.byKey(const Key('search_menu')));

  await tester.pumpAndSettle();

  await tester.tap(find.text(name));

  await tester.pumpAndSettle();

  await tester.scrollUntilVisible(
    find.text("Confirm"),
    500,
    scrollable: find.byType(Scrollable),
  );

  await tester.pumpAndSettle();

  await tester.tap(find.text('Good boy'));

  await tester.pumpAndSettle();

  await tester.tap(find.text('Confirm'));

  return name;
}
