import 'package:dima_project/bloc/order_bloc.dart';
import 'package:dima_project/constants.dart';
import 'package:dima_project/custom_widgets/app_bar.dart';
import 'package:dima_project/generated/l10n.dart';
import 'package:dima_project/home/order/chat_page.dart';
import 'package:dima_project/input/show_text.dart';
import 'package:dima_project/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderListPage extends StatelessWidget {
  const OrderListPage({
    Key? key,
    required this.isMyOffers,
  }) : super(key: key);

  final bool isMyOffers;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: KAppBar(
        text:
            isMyOffers ? S.of(context).asOfferor : S.of(context).asClient,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: spaceBetweenWidgets),
        child: ChatListWidget(
          isMyOffers: isMyOffers,
        ),
      ),
    );
  }
}

class ChatListWidget extends StatelessWidget {
  const ChatListWidget({
    Key? key,
    required this.isMyOffers,
  }) : super(key: key);

  final bool isMyOffers;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderBloc, OrderState>(
      builder: (BuildContext context, OrderState state) {
        return ListView.separated(
          itemBuilder: (BuildContext context, int i) => ShowText(
            title: isMyOffers
                ? state.myOffers[i].client.name!
                : state.acceptedOffers[i].offer.user!.name!,
            text: printDate(
              (isMyOffers ? state.myOffers : state.acceptedOffers)[i]
                  .offer
                  .startDate!,
            ),
            trailerIcon: Icons.arrow_forward_ios_outlined,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatPage(
                      order: (isMyOffers
                          ? state.myOffers
                          : state.acceptedOffers)[i],
                      isClientMe: !isMyOffers)),
            ),
          ),
          separatorBuilder: (BuildContext context, int i) => const SizedBox(
            height: spaceBetweenWidgets,
          ),
          itemCount:
              isMyOffers ? state.myOffers.length : state.acceptedOffers.length,
        );
      },
    );
  }
}
