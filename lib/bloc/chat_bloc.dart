import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dima_project/model/chat.dart';
import 'package:dima_project/model/dog.dart';
import 'package:dima_project/model/internal_user.dart';
import 'package:dima_project/model/offer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';

abstract class ChatEvent {}

class MyOfferEvent extends ChatEvent {
  final QuerySnapshot<Map> event;

  MyOfferEvent({
    required this.event,
  });
}

class AcceptedOfferEvent extends ChatEvent {
  final QuerySnapshot<Map> event;

  AcceptedOfferEvent({
    required this.event,
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
    on<MyOfferEvent>(_onMyOfferEvent);
    on<AcceptedOfferEvent>(_onAcceptedOfferEvent);

    FirebaseFirestore.instance
        .collection('orders')
        .where('user',
            isEqualTo: FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser!.uid))
        .snapshots()
        .listen(
          (event) => add(
            MyOfferEvent(
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
            AcceptedOfferEvent(
              event: event,
            ),
          ),
        );
  }

  _onAcceptedOfferEvent(
      AcceptedOfferEvent event, Emitter<ChatState> emit) async {
    List<Chat> chats = [...state.acceptedOffers];

    for (QueryDocumentSnapshot<Map> element in event.event.docs) {
      if (!element.exists) {
        continue;
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
          await (offerMap['user'] as DocumentReference).get();

      Map<String, dynamic> clientMap = userDoc.data() as Map<String, dynamic>;

      InternalUser client = InternalUser(
        uid: clientDoc.id,
        name: clientMap['name'],
        dogs: ((clientMap['dogs'] ?? []) as List)
            .map((e) => Dog(uid: e.id, fetched: false))
            .toList(),
        fetched: true,
      );

      Chat chat = Chat(
        id: element.id,
        offer: offer,
        client: client,
        messages: [
          for (var message in elementMap['messages'] ?? [])
            Message(
              text: message['message'],
              isClientMessage: message['isClientMessage'],
            )
        ],
      );

      int i = chats.indexWhere((element) => element.id == chat.id);

      if (i == -1) {
        chats.add(chat);
      } else {
        chats[i] = chat;
      }
    }

    emit(
      ChatState(
        myOffers: state.myOffers,
        acceptedOffers: chats,
      ),
    );
  }

  _onMyOfferEvent(MyOfferEvent event, Emitter<ChatState> emit) async {
    List<Chat> chats = [...state.myOffers];

    for (QueryDocumentSnapshot<Map> element in event.event.docs) {
      if (!element.exists) {
        continue;
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
          await (offerMap['user'] as DocumentReference).get();

      Map<String, dynamic> clientMap = userDoc.data() as Map<String, dynamic>;

      InternalUser client = InternalUser(
        uid: clientDoc.id,
        name: clientMap['name'],
        dogs: ((clientMap['dogs'] ?? []) as List)
            .map((e) => Dog(uid: e.id, fetched: false))
            .toList(),
        fetched: true,
      );

      Chat chat = Chat(
        id: element.id,
        offer: offer,
        client: client,
        messages: [
          for (var message in elementMap['messages'] ?? [])
            Message(
              text: message['message'],
              isClientMessage: message['isClientMessage'],
            )
        ],
      );

      int i = chats.indexWhere((element) => element.id == chat.id);

      if (i == -1) {
        chats.add(chat);
      } else {
        chats[i] = chat;
      }
    }

    emit(
      ChatState(
        myOffers: chats,
        acceptedOffers: state.acceptedOffers,
      ),
    );
  }
}
