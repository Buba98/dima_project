import 'dart:async';

import 'package:dima_project/bloc/chat_bloc.dart';
import 'package:dima_project/constants.dart';
import 'package:dima_project/custom_widgets/app_bar.dart';
import 'package:dima_project/generated/l10n.dart';
import 'package:dima_project/home/order/order_summary_page.dart';
import 'package:dima_project/input/text_input_button.dart';
import 'package:dima_project/model/chat.dart';
import 'package:dima_project/model/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    Key? key,
    required this.order,
    required this.isClientMe,
  }) : super(key: key);

  final Order order;
  final bool isClientMe;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController messageEditingController =
      TextEditingController();
  final ScrollController scrollController = ScrollController();
  bool loading = false;
  late final ChatBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = ChatBloc(order: widget.order);
  }

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
        text: widget.isClientMe
            ? widget.order.offer.user!.name
            : widget.order.client.name!,
        actionIcon: Icons.info_rounded,
        actionFunction: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => OrderSummaryPage(
                order: widget.order,
                isClientMe: widget.isClientMe,
              ),
            ),
          );
        },
      ),
      body: BlocBuilder<ChatBloc, ChatState>(
        bloc: bloc,
        builder: (BuildContext context, ChatState state) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (state.exists) {
              _scrollDown();
            } else {
              while (!(ModalRoute.of(context)?.isCurrent ?? false)) {
                Navigator.pop(context);
              }
              Navigator.pop(context);
            }
          });
          return Padding(
            padding: const EdgeInsets.all(spaceBetweenWidgets),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    controller: scrollController,
                    itemBuilder: (BuildContext context, int index) => Padding(
                      padding:
                          const EdgeInsets.only(bottom: spaceBetweenWidgets),
                      child: _ChatMessage(
                        text: state
                            .chat
                            .messages[state.chat.messages.length - index - 1]
                            .text,
                        isFromMe: (state
                                    .chat
                                    .messages[
                                        state.chat.messages.length - index - 1]
                                    .isFromClient &&
                                widget.isClientMe) ||
                            (!state
                                    .chat
                                    .messages[
                                        state.chat.messages.length - index - 1]
                                    .isFromClient &&
                                !widget.isClientMe),
                      ),
                    ),
                    itemCount: state.chat.messages.length,
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
                    bloc.add(
                      SendMessageEvent(
                        message: Message(
                          text: messageEditingController.text,
                          isFromClient: widget.isClientMe,
                        ),
                        completer: completer,
                      ),
                    );
                    messageEditingController.clear();
                    setState(() => loading = true);
                    completer.future.whenComplete(() {
                      setState(() => loading = false);
                    });
                  },
                  hintText: S.of(context).enterMessage,
                  iconButton: loading ? Icons.downloading : Icons.send,
                ),
              ],
            ),
          );
        },
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
