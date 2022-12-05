import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
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

    await collection.get().then(
      (QuerySnapshot<Map<String, dynamic>> doc) {
        for (var element in doc.docs) {
          if (!element.exists) {
            continue;
          }

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
              user: InternalUser(
                uid: (element['user'] as DocumentReference).id,
                fetched: false,
              ),
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
