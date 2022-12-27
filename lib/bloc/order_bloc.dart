import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dima_project/model/order.dart' as internal_order;
import 'package:dima_project/model/dog.dart';
import 'package:dima_project/model/internal_user.dart';
import 'package:dima_project/model/offer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';

abstract class OrderEvent {}

class InitOrderBloc extends OrderEvent {}

class _MyOfferEvent extends OrderEvent {
  final QuerySnapshot<Map> event;

  _MyOfferEvent({
    required this.event,
  });
}

class _AcceptedOfferEvent extends OrderEvent {
  final QuerySnapshot<Map> event;

  _AcceptedOfferEvent({
    required this.event,
  });
}

class OrderState {
  final List<internal_order.Order> myOffers;
  final List<internal_order.Order> acceptedOffers;

  OrderState({
    this.myOffers = const [],
    this.acceptedOffers = const [],
  });
}

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  StreamSubscription? myOfferSubscription;
  StreamSubscription? acceptedOfferSubscription;

  OrderBloc() : super(OrderState()) {
    on<_MyOfferEvent>(_onMyOfferEvent);
    on<_AcceptedOfferEvent>(_onAcceptedOfferEvent);
    // on<SendMessageEvent>(_onSendMessageEvent);
    on<InitOrderBloc>((InitOrderBloc event, Emitter<OrderState> emit) {
      myOfferSubscription?.cancel();
      myOfferSubscription = FirebaseFirestore.instance
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
      acceptedOfferSubscription?.cancel();
      acceptedOfferSubscription = FirebaseFirestore.instance
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
    });
  }

  _help(List<internal_order.Order> chats,
      QueryDocumentSnapshot<Map> element) async {
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

      if (!dogDoc.exists) {
        continue;
      }

      Map<String, dynamic> dogMap = dogDoc.data() as Map<String, dynamic>;

      dogs.add(Dog(
        uid: dogDoc.id,
        fetched: true,
        sex: dogMap['sex'],
        name: dogMap['name'],
        owner: client,
      ));
    }

    internal_order.Order chat = internal_order.Order(
      id: element.id,
      offer: offer,
      client: client,
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
      _AcceptedOfferEvent event, Emitter<OrderState> emit) async {
    List<internal_order.Order> chats = [...state.acceptedOffers];

    for (QueryDocumentSnapshot<Map> element in event.event.docs) {
      _help(chats, element);
    }

    emit(
      OrderState(
        myOffers: state.myOffers,
        acceptedOffers: chats,
      ),
    );
  }

  _onMyOfferEvent(_MyOfferEvent event, Emitter<OrderState> emit) async {
    List<internal_order.Order> chats = [...state.myOffers];

    for (QueryDocumentSnapshot<Map> element in event.event.docs) {
      _help(chats, element);
    }

    emit(
      OrderState(
        myOffers: chats,
        acceptedOffers: state.acceptedOffers,
      ),
    );
  }
}
