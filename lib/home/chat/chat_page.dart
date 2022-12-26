import 'dart:async';

import 'package:dima_project/bloc/chat_bloc.dart';
import 'package:dima_project/constants.dart';
import 'package:dima_project/custom_widgets/app_bar.dart';
import 'package:dima_project/generated/l10n.dart';
import 'package:dima_project/home/chat/order_summary_page.dart';
import 'package:dima_project/input/text_input_button.dart';
import 'package:dima_project/model/chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatPage extends StatefulWidget {
  ChatPage({
    Key? key,
    required this.chat,
    required this.isClientMe,
  }) : super(key: key);

  final Chat chat;
  final bool isClientMe;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController messageEditingController =
      TextEditingController();
  final ScrollController scrollController = ScrollController();
  bool loading = false;

  void _scrollDown() {
    scrollController.animateTo(
      scrollController.position.minScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: KAppBar(
        text: widget.chat.offer.user!.name,
        actionIcon: Icons.info_rounded,
        actionFunction: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => OrderSummaryPage(
                chat: widget.chat,
              ),
            ),
          );
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(spaceBetweenWidgets),
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<ChatBloc, ChatState>(
                builder: (BuildContext context, ChatState state) {
                  Chat chat = (widget.isClientMe
                      ? state.acceptedOffers
                      : state.myOffers)[(widget.isClientMe
                          ? state.acceptedOffers
                          : state.myOffers)
                      .indexWhere((element) => element.id == widget.chat.id)];

                  WidgetsBinding.instance
                      .addPostFrameCallback((_) => _scrollDown());

                  return ListView.builder(
                    reverse: true,
                    controller: scrollController,
                    itemBuilder: (BuildContext context, int index) => Padding(
                      padding:
                          const EdgeInsets.only(bottom: spaceBetweenWidgets),
                      child: _ChatMessage(
                        text: chat
                            .messages[chat.messages.length - index - 1].text,
                        isFromMe: chat
                                .messages[chat.messages.length - index - 1]
                                .isClientMessage &&
                            widget.isClientMe,
                      ),
                    ),
                    itemCount: chat.messages.length,
                  );
                },
              ),
            ),
            const SizedBox(
              height: spaceBetweenWidgets,
            ),
            TextInputButton(
              maxLines: 4,
              textInputType: TextInputType.multiline,
              textEditingController: messageEditingController,
              onTap: () {
                if (loading == true) {
                  return;
                }
                Completer completer = Completer();
                context.read<ChatBloc>().add(
                      SendMessageEvent(
                        chat: widget.chat,
                        message: Message(
                          text: messageEditingController.text,
                          isClientMessage: widget.isClientMe,
                        ),
                        completer: completer,
                      ),
                    );
                setState(() => loading = true);
                completer.future.whenComplete(() {
                  setState(() => loading = false);
                  messageEditingController.clear();
                });
              },
              hintText: S.of(context).enterMessage,
              iconButton: loading ? Icons.downloading : Icons.send,
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatMessage extends StatelessWidget {
  const _ChatMessage({
    Key? key,
    required this.text,
    required this.isFromMe,
  }) : super(key: key);

  final String text;
  final bool isFromMe;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isFromMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(spaceBetweenWidgets / 2),
        ),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: constraints.minWidth,
                maxWidth: constraints.maxWidth * 5 / 6,
                minHeight: constraints.minHeight,
                maxHeight: constraints.maxHeight,
              ),
              child: Padding(
                padding: const EdgeInsets.all(spaceBetweenWidgets / 2),
                child: Text(text),
              ),
            );
          },
        ),
      ),
    );
  }
}
