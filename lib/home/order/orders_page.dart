import 'package:dima_project/bloc/offer_bloc.dart';
import 'package:dima_project/constants.dart';
import 'package:dima_project/custom_widgets/app_bar.dart';
import 'package:dima_project/generated/l10n.dart';
import 'package:dima_project/home/order/my_offer_card.dart';
import 'package:dima_project/home/order/order_list_page.dart';
import 'package:dima_project/input/show_text.dart';
import 'package:dima_project/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessagingPage extends StatelessWidget {
  const MessagingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: KAppBar(
        text: S.of(context).orders,
      ),
      body: isTablet(context)
          ? const MessagingPageTablet()
          : const _MessagingPagePhone(),
    );
  }
}

class MessagingPageTablet extends StatefulWidget {
  const MessagingPageTablet({Key? key}) : super(key: key);

  @override
  State<MessagingPageTablet> createState() => _MessagingPageTabletState();
}

class _MessagingPageTabletState extends State<MessagingPageTablet> {
  Widget? focus;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: spaceBetweenWidgets),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.of(context).chat,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(),
                ShowText(
                  text: S.of(context).myOffers,
                  trailerIcon: Icons.arrow_forward_ios_outlined,
                  onPressed: () => setState(
                    () => focus = const ChatListWidget(isMyOffers: true),
                  ),
                ),
                const SizedBox(
                  height: spaceBetweenWidgets,
                ),
                ShowText(
                  text: S.of(context).acceptedOffers,
                  trailerIcon: Icons.arrow_forward_ios_outlined,
                  onPressed: () => setState(
                    () => focus = const ChatListWidget(isMyOffers: false),
                  ),
                ),
                const SizedBox(
                  height: spaceBetweenWidgets,
                ),
                Text(
                  S.of(context).myOffers,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(),
              ],
            ),
          ),
          const SizedBox(
            width: spaceBetweenWidgets,
          ),
          Expanded(
            flex: 7,
            child: focus ?? Container(),
          )
        ],
      ),
    );
  }
}

class _MessagingPagePhone extends StatefulWidget {
  const _MessagingPagePhone({Key? key}) : super(key: key);

  @override
  State<_MessagingPagePhone> createState() => _MessagingPagePhoneState();
}

class _MessagingPagePhoneState extends State<_MessagingPagePhone> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: spaceBetweenWidgets),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).chat,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(),
          ShowText(
            text: S.of(context).myOffers,
            trailerIcon: Icons.arrow_forward_ios_outlined,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const OrderListPage(
                    isMyOffers: true,
                  ),
                ),
              );
            },
          ),
          const SizedBox(
            height: spaceBetweenWidgets,
          ),
          ShowText(
            text: S.of(context).acceptedOffers,
            trailerIcon: Icons.arrow_forward_ios_outlined,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const OrderListPage(
                    isMyOffers: false,
                  ),
                ),
              );
            },
          ),
          const SizedBox(
            height: spaceBetweenWidgets,
          ),
          Text(
            S.of(context).myOffers,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(),
          ...context
              .read<OfferBloc>()
              .state
              .offers
              .where((element) =>
                  element.user!.uid == FirebaseAuth.instance.currentUser!.uid)
              .map<MyOfferCard>(
                (e) => MyOfferCard(
                  offer: e,
                ),
              )
              .toList()
        ],
      ),
    );
  }
}