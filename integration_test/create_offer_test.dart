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

          final int price = await createOfferSteps(tester);

          await tester.tap(find.byKey(const Key('orders_menu')));

          await tester.pumpAndSettle();

          expect(find.text('\$${price.toStringAsFixed(2)}'),
              findsAtLeastNWidgets(1));
        },
      );
    },
  );
}
