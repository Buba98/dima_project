import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dima_project/model/dog.dart';
import 'package:dima_project/model/internal_user.dart';
import 'package:dima_project/model/offer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        .where('order', isEqualTo: documentReference)
        .get();

    for (var element in querySnapshot.docs) {
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(element.id)
          .delete();
      await element.reference.delete();
    }

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
    event.firestoreModel['user'] = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid);

    await FirebaseFirestore.instance
        .collection('offers')
        .add(event.firestoreModel);
  }

  _onLoadEvent(_LoadEvent event, Emitter<OfferState> emit) async {
    List<Offer> offers = [];

    for (QueryDocumentSnapshot<Map> element in event.querySnapshot.docs) {
      if (!element.exists) {
        continue;
      }

      DocumentSnapshot documentSnapshot =
          await (element['user'] as DocumentReference).get();

      if (!documentSnapshot.exists) {
        continue;
      }

      Map<String, dynamic> map =
          documentSnapshot.data()! as Map<String, dynamic>;

      InternalUser user = InternalUser(
        uid: documentSnapshot.id,
        name: map['name'],
        bio: map['bio'],
        dogs: ((map['dogs'] ?? []) as List)
            .map((e) => Dog(uid: e.id, fetched: false))
            .toList(),
        fetched: true,
      );

      offers.add(
        Offer(
          id: element.id,
          startDate: (element['start_date'] as Timestamp).toDate(),
          duration: (element['end_date'] as Timestamp)
              .toDate()
              .difference((element['start_date'] as Timestamp).toDate()),
          price: element['price'],
          activities: [
            for (String e in element['activities'] as List)
              Activity(activity: e)
          ],
          position: LatLng(element['position'][0], element['position'][1]),
          user: user,
          fetched: true,
        ),
      );
    }

    emit(OfferState(offers: offers));
  }
}
