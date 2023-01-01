import 'package:dima_project/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group(
    'location test',
    () {
      testWidgets(
        'location not available test',
        (WidgetTester tester) async {
          await app.main();
          await tester.pumpAndSettle();

          await loginSteps(tester);

          await tester.pumpAndSettle();

          final String name = await createOrderSteps(tester);

          await tester.pumpAndSettle();

          await waitForNSeconds(tester);

          await tester.pumpAndSettle();

          await tester.tap(find.byKey(const Key('orders_menu')));

          await tester.pumpAndSettle();

          await tester.tap(find.text('As client'));

          await pumpUntilFound(tester, find.text(name));

          await tester.tap(find.text(name));

          await tester.pumpAndSettle();

          await tester.tap(find.byIcon(Icons.info_rounded));

          await tester.scrollUntilVisible(
            find.text('View live location'),
            500,
            scrollable: find.byType(Scrollable),
          );

          await tester.tap(find.text('View live location'));

          await pumpUntilFound(tester, find.text('Live location is not available'));

          expect(find.text('Live location is not available'), findsOneWidget);
        },
      );
    },
  );
}
