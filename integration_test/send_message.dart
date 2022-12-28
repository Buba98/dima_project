import 'package:dima_project/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

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

          await loginSteps(tester);

          await tester.pumpAndSettle();

          final String name = await createOrderSteps(tester);

          await tester.pumpAndSettle();

          await tester.tap(find.byKey(const Key('orders_menu')));

          await tester.pumpAndSettle();

          await tester.tap(find.text('Accepted offers'));

          await pumpUntilFound(tester, find.text(name));
          
          await tester.tap(find.text(name));

          await tester.pumpAndSettle();

          const String message = 'Beautiful message';
          
          await tester.enterText(find.text('Enter message'), message);

          await tester.pumpAndSettle();

          await tester.testTextInput.receiveAction(TextInputAction.done);

          await tester.pumpAndSettle();
          
          await tester.tap(find.byIcon(Icons.send));

          await tester.pumpAndSettle();
          
          pumpUntilFound(tester, find.byIcon(Icons.downloading));

          pumpUntilFound(tester, find.byIcon(Icons.send));

          pumpUntilFound(tester, find.text(message));

          expect(find.text(message), findsAtLeastNWidgets(1));

        },
      );
    },
  );
}
