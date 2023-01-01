import 'dart:io';

import 'package:dima_project/main.dart' as app;
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group(
    'dog test',
    () {
      testWidgets(
        'dog creation test',
        (WidgetTester tester) async {
          await app.main();
          await tester.pumpAndSettle();

          await loginSteps(tester);

          await tester.pumpAndSettle();

          await tester.tap(find.byKey(const Key('profile_menu')));

          await tester.pumpAndSettle();

          String name = await createDogSteps(tester);

          expect(find.text(name), findsAtLeastNWidgets(1));
        },
      );
    },
  );
}
