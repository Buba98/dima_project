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
    on<InitOrderBloc>((InitOrderBloc event, Emitter<OrderState> emit) {
      myOfferSubscription?.cancel();
      acceptedOfferSubscription?.cancel();
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
      QueryDocumentSnapshot<Map> orderDocument) async {
    if (!orderDocument.exists) {
      return;
    }

    DocumentSnapshot<Map> offerDocument = await orderDocument['offer'].get();

    if (!offerDocument.exists) {
      return;
    }

    DocumentSnapshot<Map> userDocument = await offerDocument['user'].get();

    if (!userDocument.exists) {
      return;
    }

    InternalUser user = InternalUser(
      uid: userDocument.id,
      name: userDocument['name'],
      bio: userDocument['bio'],
      dogs: ((userDocument['dogs'] ?? []) as List)
          .map((e) => Dog(uid: e.id, fetched: false))
          .toList(),
      fetched: true,
    );

    Offer offer = Offer(
      id: offerDocument.id,
      startDate: (offerDocument['start_date'] as Timestamp).toDate(),
      duration: (offerDocument['end_date'] as Timestamp)
          .toDate()
          .difference((offerDocument['start_date'] as Timestamp).toDate()),
      price: offerDocument['price'],
      activities: [
        for (String e in offerDocument['activities'] as List)
          Activity(activity: e)
      ],
      position:
          LatLng(offerDocument['position'][0], offerDocument['position'][1]),
      user: user,
      fetched: true,
    );

    DocumentSnapshot<Map> clientDocument = await orderDocument['client'].get();

    if (!clientDocument.exists) {
      return;
    }

    InternalUser client = InternalUser(
      uid: clientDocument.id,
      name: clientDocument['name'],
      bio: clientDocument['bio'],
      dogs: ((clientDocument['dogs'] ?? []) as List)
          .map((e) => Dog(uid: e.id, fetched: false))
          .toList(),
      fetched: true,
    );

    List<Dog> dogs = [];
    DocumentSnapshot<Map> dogDocument;

    for (DocumentReference<Map> dogReference in orderDocument['dogs']) {
      dogDocument = await dogReference.get();

      if (!dogDocument.exists) {
        return;
      }

      dogs.add(Dog(
        uid: dogDocument.id,
        fetched: true,
        sex: dogDocument['sex'],
        name: dogDocument['name'],
        owner: client,
      ));
    }

    internal_order.Order chat = internal_order.Order(
      id: orderDocument.id,
      offer: offer,
      client: client,
      dogs: dogs,
    );

    // int i = chats.indexWhere((element) => element.id == chat.id);

    // if (i == -1) {
    chats.add(chat);
    // } else {
    //   chats[i] = chat;
    // }
  }

  _onAcceptedOfferEvent(
      _AcceptedOfferEvent event, Emitter<OrderState> emit) async {
    List<internal_order.Order> chats = [];

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
    List<internal_order.Order> chats = [];

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
