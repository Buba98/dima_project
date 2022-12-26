import 'package:dima_project/constants.dart';
import 'package:dima_project/custom_widgets/app_bar.dart';
import 'package:dima_project/generated/l10n.dart';
import 'package:dima_project/input/text_input_button.dart';
import 'package:dima_project/model/chat.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: KAppBar(
        text: widget.chat.offer.user!.name,
      ),
      body: Padding(
        padding: const EdgeInsets.all(spaceBetweenWidgets),
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemBuilder: (BuildContext context, int index) => _ChatMessage(
                  text: widget.chat.messages[index].text,
                  isFromMe: widget.chat.messages[index].isClientMessage && widget.isClientMe,
                ),
                separatorBuilder: (BuildContext context, int index) =>
                    const SizedBox(
                  height: spaceBetweenWidgets,
                ),
                itemCount: widget.chat.messages.length,
              ),
            ),
            Expanded(child: Container()),
            TextInputButton(
              maxLines: 4,
              textInputType: TextInputType.multiline,
              textEditingController: messageEditingController,
              onTap: () {},
              hintText: S.of(context).enterMessage,
              iconButton: Icons.send,
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
        }),
      ),
    );
  }
}
