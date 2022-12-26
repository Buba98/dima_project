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

class LoadEvent extends OfferEvent {
  final Completer? completer;

  LoadEvent({
    this.completer,
  });
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

class OfferState {
  final List<Offer> offers;

  OfferState({
    this.offers = const [],
  });
}

class OfferBloc extends Bloc<OfferEvent, OfferState> {
  OfferBloc() : super(OfferState()) {
    on<AddOfferEvent>(_onAddOfferEvent);
    on<LoadEvent>(_onLoadEvent);
    on<OrderEvent>(_onOrderEvent);
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

  _onLoadEvent(LoadEvent event, Emitter<OfferState> emit) async {
    List<Offer> offers = [];

    Query<Map<String, dynamic>> collection =
        FirebaseFirestore.instance.collection('offers');

    collection = collection.where(
      'start_date',
      isGreaterThan: Timestamp.now(),
    );

    collection = collection.orderBy('start_date');

    await collection.get().then(
      (QuerySnapshot<Map<String, dynamic>> doc) async {
        for (var element in doc.docs) {
          if (!element.exists) {
            continue;
          }

          DocumentSnapshot documentSnapshot =
              await (element['user'] as DocumentReference).get();

          if (!documentSnapshot.exists || documentSnapshot.id == FirebaseAuth.instance.currentUser!.uid) {
            continue;
          }

          Map<String, dynamic> map =
              documentSnapshot.data()! as Map<String, dynamic>;

          InternalUser user = InternalUser(
            uid: documentSnapshot.id,
            name: map['name'],
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
      },
      onError: (e) => throw Exception(e),
    );

    emit(OfferState(offers: offers));

    event.completer?.complete();
  }
}
