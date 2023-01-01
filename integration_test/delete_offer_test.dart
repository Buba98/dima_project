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

          await loginSteps(tester);

          await tester.pumpAndSettle();

          int price = await createOfferSteps(tester);

          await tester.pumpAndSettle();

          await waitForNSeconds(tester);

          await tester.pumpAndSettle();

          await tester.tap(find.byKey(const Key('orders_menu')));

          await tester.tap(find.text('\$${price.toStringAsFixed(2)}'));

          await tester.pumpAndSettle();

          await tester.scrollUntilVisible(
            find.text("Delete offer"),
            500,
            scrollable: find.byType(Scrollable),
          );

          await tester.pumpAndSettle();

          await tester.tap(find.text("Delete offer"));

          await pumpUntilNotFound(tester, find.text('$price'));

          expect(find.text('$price'), findsNothing);
        },
      );
    },
  );
}
