import 'package:dima_project/custom_widgets/app_bar.dart';
import 'package:dima_project/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
      body: ChatListWidget(
        isMyOffers: isMyOffers,
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
    return const Placeholder();
  }
}
