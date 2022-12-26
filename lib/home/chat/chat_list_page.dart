import 'package:dima_project/bloc/chat_bloc.dart';
import 'package:dima_project/constants.dart';
import 'package:dima_project/custom_widgets/app_bar.dart';
import 'package:dima_project/generated/l10n.dart';
import 'package:dima_project/home/chat/chat_page.dart';
import 'package:dima_project/input/show_text.dart';
import 'package:dima_project/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({
    Key? key,
    required this.isMyOffers,
  }) : super(key: key);

  final bool isMyOffers;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: KAppBar(
        text:
            isMyOffers ? S.of(context).myOffers : S.of(context).acceptedOffers,
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
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (BuildContext context, ChatState state) {
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
                builder: (context) => ChatPage(chat: (isMyOffers ? state.myOffers : state.acceptedOffers)[i], isClientMe: !isMyOffers)
              ),
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
