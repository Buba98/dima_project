import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dima_project/model/chat.dart';
import 'package:dima_project/model/dog.dart';
import 'package:dima_project/model/internal_user.dart';
import 'package:dima_project/model/offer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';

abstract class ChatEvent {}

class _MyOfferEvent extends ChatEvent {
  final QuerySnapshot<Map> event;

  _MyOfferEvent({
    required this.event,
  });
}

class _AcceptedOfferEvent extends ChatEvent {
  final QuerySnapshot<Map> event;

  _AcceptedOfferEvent({
    required this.event,
  });
}

class SendMessageEvent extends ChatEvent {
  final Chat chat;
  final Message message;

  SendMessageEvent({
    required this.chat,
    required this.message,
  });
}

class ChatState {
  final List<Chat> myOffers;
  final List<Chat> acceptedOffers;

  ChatState({
    this.myOffers = const [],
    this.acceptedOffers = const [],
  });
}

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatState()) {
    on<_MyOfferEvent>(_onMyOfferEvent);
    on<_AcceptedOfferEvent>(_onAcceptedOfferEvent);
    on<SendMessageEvent>(_onSendMessageEvent);

    FirebaseFirestore.instance
        .collection('orders')
        .where('user',
            isEqualTo: FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser!.uid))
        .snapshots()
        .listen(
          (event) => add(
            _MyOfferEvent(
              event: event,
            ),
          ),
        );

    FirebaseFirestore.instance
        .collection('orders')
        .where('client',
            isEqualTo: FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser!.uid))
        .snapshots()
        .listen(
          (event) => add(
            _AcceptedOfferEvent(
              event: event,
            ),
          ),
        );
  }

  _onSendMessageEvent(SendMessageEvent event, Emitter<ChatState> emit) {
    FirebaseFirestore.instance.collection('orders').doc(event.chat.id).update({
      'messages': FieldValue.arrayUnion([
        {
          'is_client': event.message.isClientMessage,
          'message': event.message.text
        }
      ]),
    });
  }

  _help(List<Chat> chats, QueryDocumentSnapshot<Map> element) async {
    if (!element.exists) {
      return;
    }

    Map<String, dynamic> elementMap = element.data() as Map<String, dynamic>;

    DocumentSnapshot offerDoc =
        await (elementMap['offer'] as DocumentReference).get();

    Map<String, dynamic> offerMap = offerDoc.data() as Map<String, dynamic>;

    DocumentSnapshot userDoc =
        await (offerMap['user'] as DocumentReference).get();

    Map<String, dynamic> userMap = userDoc.data() as Map<String, dynamic>;

    InternalUser user = InternalUser(
      uid: userDoc.id,
      name: userMap['name'],
      dogs: ((userMap['dogs'] ?? []) as List)
          .map((e) => Dog(uid: e.id, fetched: false))
          .toList(),
      fetched: true,
    );

    Offer offer = Offer(
      id: offerDoc.id,
      startDate: (offerMap['start_date'] as Timestamp).toDate(),
      duration: (offerMap['end_date'] as Timestamp)
          .toDate()
          .difference((offerMap['start_date'] as Timestamp).toDate()),
      price: offerMap['price'],
      activities: [
        for (String e in offerMap['activities'] as List) Activity(activity: e)
      ],
      position: LatLng(offerMap['position'][0], offerMap['position'][1]),
      user: user,
      fetched: true,
    );

    DocumentSnapshot clientDoc =
        await (elementMap['client'] as DocumentReference).get();

    Map<String, dynamic> clientMap = userDoc.data() as Map<String, dynamic>;

    InternalUser client = InternalUser(
      uid: clientDoc.id,
      name: clientMap['name'],
      dogs: ((clientMap['dogs'] ?? []) as List)
          .map((e) => Dog(uid: e.id, fetched: false))
          .toList(),
      fetched: true,
    );

    List<Dog> dogs = [];

    for (DocumentReference dogRef in elementMap['dogs']) {
      DocumentSnapshot dogDoc = await dogRef.get();

      Map<String, dynamic> dogMap = dogDoc.data() as Map<String, dynamic>;

      dogs.add(Dog(
        uid: dogDoc.id,
        fetched: true,
        sex: dogMap['sex'],
        name: dogMap['name'],
        owner: client,
      ));
    }

    Chat chat = Chat(
      id: element.id,
      offer: offer,
      client: client,
      messages: [
        for (var message in elementMap['messages'] ?? [])
          Message(
            text: message['message'],
            isClientMessage: message['is_client'],
          )
      ],
      dogs: dogs,
    );

    int i = chats.indexWhere((element) => element.id == chat.id);

    if (i == -1) {
      chats.add(chat);
    } else {
      chats[i] = chat;
    }
  }

  _onAcceptedOfferEvent(
      _AcceptedOfferEvent event, Emitter<ChatState> emit) async {
    List<Chat> chats = [...state.acceptedOffers];

    for (QueryDocumentSnapshot<Map> element in event.event.docs) {
      _help(chats, element);
    }

    emit(
      ChatState(
        myOffers: state.myOffers,
        acceptedOffers: chats,
      ),
    );
  }

  _onMyOfferEvent(_MyOfferEvent event, Emitter<ChatState> emit) async {
    List<Chat> chats = [...state.myOffers];

    for (QueryDocumentSnapshot<Map> element in event.event.docs) {
      _help(chats, element);
    }

    emit(
      ChatState(
        myOffers: chats,
        acceptedOffers: state.acceptedOffers,
      ),
    );
  }
}
