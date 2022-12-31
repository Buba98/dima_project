import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dima_project/model/dog.dart';
import 'package:dima_project/model/internal_user.dart';
import 'package:dima_project/model/offer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocode/geocode.dart';
import 'package:latlong2/latlong.dart';

abstract class OfferEvent {}

class AddOfferEvent extends OfferEvent {
  final Map<String, dynamic> firestoreModel;

  AddOfferEvent({
    required DateTime startDate,
    required Duration duration,
    required double price,
    required List<String> activities,
    required LatLng position,
  }) : firestoreModel = {
          'start_date': Timestamp.fromDate(startDate),
          'end_date': Timestamp.fromDate(startDate.add(duration)),
          'price': price,
          'activities': activities,
          'position': [position.latitude, position.longitude],
        };
}

class InitOfferBloc extends OfferEvent {}

class _LoadEvent extends OfferEvent {
  QuerySnapshot<Map> querySnapshot;

  _LoadEvent(this.querySnapshot);
}

class OrderEvent extends OfferEvent {
  final Offer offer;
  final List<Dog> dogs;
  final Completer? completer;

  OrderEvent({
    required this.dogs,
    required this.offer,
    this.completer,
  });
}

class DeleteOfferEvent extends OfferEvent {
  final Offer offer;
  final Completer? completer;

  DeleteOfferEvent({
    required this.offer,
    this.completer,
  });
}

class OfferState {
  final List<Offer> offers;

  OfferState({
    this.offers = const [],
  });
}

class OfferBloc extends Bloc<OfferEvent, OfferState> {
  StreamSubscription? streamSubscription;

  OfferBloc() : super(OfferState()) {
    on<AddOfferEvent>(_onAddOfferEvent);
    on<_LoadEvent>(_onLoadEvent);
    on<OrderEvent>(_onOrderEvent);
    on<DeleteOfferEvent>(_onDeleteOfferEvent);
    on<InitOfferBloc>((InitOfferBloc event, Emitter<OfferState> emit) {
      streamSubscription?.cancel();
      streamSubscription = FirebaseFirestore.instance
          .collection('offers')
          .where(
            'start_date',
            isGreaterThan: Timestamp.now(),
          )
          .orderBy('start_date')
          .snapshots()
          .listen((event) {
        add(_LoadEvent(event));
      });
    });
  }

  _onDeleteOfferEvent(DeleteOfferEvent event, Emitter<OfferState> emit) async {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('offers').doc(event.offer.id);

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('orders')
        .where('offer', isEqualTo: documentReference)
        .get();

    for (QueryDocumentSnapshot element in querySnapshot.docs) {
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(element.id)
          .delete();
      await element.reference.delete();
    }

    await FirebaseFirestore.instance
        .collection('live_location')
        .doc(event.offer.id)
        .delete();

    await documentReference.delete();
  }

  _onOrderEvent(OrderEvent event, Emitter<OfferState> emit) async {
    QuerySnapshot<Map> querySnapshot = await FirebaseFirestore.instance
        .collection('orders')
        .where(
          'client',
          isEqualTo: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid),
        )
        .get();

    if (querySnapshot.docs.isEmpty || !querySnapshot.docs[0].exists) {
      DocumentReference<Map> order =
          await FirebaseFirestore.instance.collection('orders').add(
        {
          'client': FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid),
          'offer': FirebaseFirestore.instance
              .collection('offers')
              .doc(event.offer.id),
          'user': FirebaseFirestore.instance
              .collection('users')
              .doc(event.offer.user!.uid),
          'dogs': [
            for (Dog dog in event.dogs)
              FirebaseFirestore.instance.collection('dogs').doc(dog.uid),
          ],
        },
      );
      await FirebaseFirestore.instance.collection('chats').doc(order.id).set({
        'order': order,
      });
    } else {
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(querySnapshot.docs[0].id)
          .update({
        'dogs': [
          for (Dog dog in event.dogs)
            FirebaseFirestore.instance.collection('dogs').doc(dog.uid),
        ],
      });
    }

    event.completer?.complete();
  }

  _onAddOfferEvent(AddOfferEvent event, Emitter<OfferState> emit) async {
    try {
      Address address = await GeoCode().reverseGeocoding(
        latitude: event.firestoreModel['position'][0],
        longitude: event.firestoreModel['position'][1],
      );

      event.firestoreModel['location'] =
          '${address.streetAddress ?? ''} ${address.streetNumber ?? ''} ${address.city ?? ''}';
    } catch (e) {
      event.firestoreModel['location'] = 'Unknown location';
    }

    event.firestoreModel['user'] = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid);

    await FirebaseFirestore.instance
        .collection('offers')
        .add(event.firestoreModel);
  }

  _onLoadEvent(_LoadEvent event, Emitter<OfferState> emit) async {
    List<Offer> offers = [];

    for (QueryDocumentSnapshot<Map> offerDocument in event.querySnapshot.docs) {
      if (!offerDocument.exists) {
        continue;
      }
      if (DateTime.now()
          .isAfter((offerDocument['end_date'] as Timestamp).toDate())) {
        add(DeleteOfferEvent(
            offer: Offer(
          id: offerDocument.id,
          fetched: false,
        )));
        continue;
      }

      DocumentSnapshot<Map> userDocument = await offerDocument['user'].get();

      if (!userDocument.exists) {
        continue;
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

      offers.add(
        Offer(
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
          position: LatLng(
              offerDocument['position'][0], offerDocument['position'][1]),
          user: user,
          fetched: true,
          location: offerDocument['location'],
        ),
      );
    }

    emit(OfferState(offers: offers));
  }
}
