import 'package:flutter/cupertino.dart';

import 'create_offer_phone_widget.dart';
import 'create_offer_tablet_widget.dart';

class CreateOfferScreen extends StatelessWidget {
  const CreateOfferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Widget child;
    if(MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.shortestSide < 550) {
      child = const CreateOfferPhoneWidget();
    } else {
      child = const CreateOfferTabletWidget();
    }
    return Center(
      child: child,

    );
  }
}
