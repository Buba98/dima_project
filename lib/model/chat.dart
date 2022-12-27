import 'package:dima_project/model/order.dart';

class Chat {
  final Order order;
  final List<Message> messages;

  Chat({
    required this.order,
    required this.messages,
  });
}

class Message {
  final String text;
  final bool isFromClient;

  Message({
    required this.text,
    required this.isFromClient,
  });
}
