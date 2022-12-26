import 'package:dima_project/constants.dart';
import 'package:dima_project/custom_widgets/app_bar.dart';
import 'package:dima_project/generated/l10n.dart';
import 'package:dima_project/home/chat/chat_list_page.dart';
import 'package:dima_project/input/show_text.dart';
import 'package:dima_project/utils/utils.dart';
import 'package:flutter/material.dart';

class MessagingPage extends StatelessWidget {
  const MessagingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: KAppBar(
        text: S.of(context).chat,
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
              children: [
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
        children: [
          ShowText(
            text: S.of(context).myOffers,
            trailerIcon: Icons.arrow_forward_ios_outlined,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChatListPage(
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
                  builder: (context) => const ChatListPage(
                    isMyOffers: false,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
