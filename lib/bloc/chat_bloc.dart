import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dima_project/model/chat.dart';
import 'package:dima_project/model/order.dart' as internal_order;
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatEvent {}

class _LoadChat extends ChatEvent {
  final DocumentSnapshot<Map> event;

  _LoadChat(this.event);
}

class SendMessageEvent extends ChatEvent {
  final Message message;
  final Completer? completer;

  SendMessageEvent({
    required this.message,
    this.completer,
  });
}

class ChatState {
  final Chat chat;

  ChatState(this.chat);
}

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final internal_order.Order order;

  ChatBloc({
    required this.order,
  }) : super(
          ChatState(
            Chat(
              order: order,
              messages: [],
            ),
          ),
        ) {
    on<SendMessageEvent>(_onSendMessageEvent);
    on<_LoadChat>(_onLoadChat);

    FirebaseFirestore.instance
        .collection('chats')
        .doc(order.id)
        .snapshots()
        .listen((event) {
      add(_LoadChat(event));
    });
  }

  _onSendMessageEvent(SendMessageEvent event, Emitter<ChatState> emit) async {
    await FirebaseFirestore.instance.collection('chats').doc(order.id).update({
      'messages': FieldValue.arrayUnion([
        {
          'is_from_client': event.message.isFromClient,
          'message': event.message.text
        }
      ]),
    });
    event.completer?.complete();
  }

  _onLoadChat(_LoadChat event, Emitter<ChatState> emit) {
    if (!event.event.exists) {
      FirebaseFirestore.instance.collection('chats').doc(order.id).set({
        'order': FirebaseFirestore.instance.collection('orders').doc(order.id),
      });
    }

    Map? elementMap = event.event.data();

    if (elementMap == null) {
      return;
    }

    Chat chat = Chat(
      order: order,
      messages: [
        for (var message in elementMap['messages'] ?? [])
          Message(
            text: message['message'],
            isFromClient: message['is_from_client'],
          )
      ],
    );
    emit(ChatState(chat));
  }
}
