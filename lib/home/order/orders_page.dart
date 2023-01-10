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

import '../search/offer_summary_page.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: KAppBar(
        text: S.of(context).orders,
      ),
      body: isTablet(context) ? const _OrdersPageTablet() : const _OrdersPagePhone(),
    );
  }
}

class _OrdersPageTablet extends StatefulWidget {
  const _OrdersPageTablet({Key? key}) : super(key: key);

  @override
  State<_OrdersPageTablet> createState() => _OrdersPageTabletState();
}

class _OrdersPageTabletState extends State<_OrdersPageTablet> {
  Widget? focus;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: spaceBetweenWidgets),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: BlocBuilder<OfferBloc, OfferState>(
              builder: (BuildContext context, OfferState state) {
                return Column(
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
                      text: S.of(context).asOfferor,
                      trailerIcon: Icons.arrow_forward_ios_outlined,
                      onPressed: () => setState(
                        () => focus = const ChatListWidget(isMyOffers: true),
                      ),
                    ),
                    const SizedBox(
                      height: spaceBetweenWidgets,
                    ),
                    ShowText(
                      text: S.of(context).asClient,
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
                    Expanded(
                      child: ListView(
                        children: state.offers
                            .where((element) =>
                                element.user!.uid ==
                                FirebaseAuth.instance.currentUser!.uid)
                            .map<MyOfferCard>(
                              (e) => MyOfferCard(
                                offer: e,
                                onTap: () => setState(
                                  () => focus = OfferSummaryWidget(offer: e),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(
            width: spaceBetweenWidgets,
          ),
          Expanded(
            flex: 1,
            child: focus ?? Container(),
          )
        ],
      ),
    );
  }
}

class _OrdersPagePhone extends StatelessWidget {
  const _OrdersPagePhone({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: spaceBetweenWidgets),
      child: BlocBuilder<OfferBloc, OfferState>(
        builder: (BuildContext context, OfferState state) {
          return Column(
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
                text: S.of(context).asOfferor,
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
                text: S.of(context).asClient,
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
              Expanded(
                child: ListView(
                  children: state.offers
                      .where((element) =>
                          element.user!.uid ==
                          FirebaseAuth.instance.currentUser!.uid)
                      .map<MyOfferCard>(
                        (e) => MyOfferCard(
                          offer: e,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => OfferSummaryPage(
                                offer: e,
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
