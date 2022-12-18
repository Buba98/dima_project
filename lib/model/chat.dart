import 'package:dima_project/model/internal_user.dart';
import 'package:dima_project/model/offer.dart';

class Chat {
  Chat({
    required this.id,
    required this.offer,
    required this.client,
    required this.messages,
  });

  final String id;
  final Offer offer;
  final InternalUser client;
  final List<Message> messages;
}

class Message {
  Message({
    required this.text,
    required this.isClientMessage,
  });

  final String text;
  final bool isClientMessage;
}
