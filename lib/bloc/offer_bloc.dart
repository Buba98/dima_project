import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dima_project/model/filter.dart';
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
          'activities': {for (String v in activities) v: true},
          'position': [position.latitude, position.longitude],
        };
}

class LoadEvent extends OfferEvent {
  final Completer? completer;
  final List<Filter> filters;

  LoadEvent({
    this.completer,
    required this.filters,
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

    for (Filter filter in event.filters) {
      switch (filter.filterType) {
        case FilterType.lessThan:
          collection =
              collection.where(filter.field, isLessThan: filter.parameter);
          break;
        case FilterType.lessOrEqual:
          collection = collection.where(filter.field,
              isLessThanOrEqualTo: filter.parameter);
          break;
        case FilterType.equalTo:
          collection =
              collection.where(filter.field, isEqualTo: filter.parameter);
          break;
        case FilterType.greaterThan:
          collection =
              collection.where(filter.field, isGreaterThan: filter.parameter);
          break;
        case FilterType.greaterOrEqualTo:
          collection = collection.where(filter.field,
              isGreaterThanOrEqualTo: filter.parameter);
          break;
        case FilterType.notEqualTo:
          collection =
              collection.where(filter.field, isNotEqualTo: filter.parameter);
          break;
        case FilterType.arrayContains:
          collection =
              collection.where(filter.field, arrayContains: filter.parameter);
          break;
        case FilterType.arrayContainsAny:
          collection = collection.where(filter.field,
              arrayContainsAny: filter.parameter as List<Object>);
          break;
        case FilterType.isIn:
          collection = collection.where(filter.field,
              whereIn: filter.parameter as List<Object>);
          break;
        case FilterType.isNotIn:
          collection = collection.where(filter.field,
              whereNotIn: filter.parameter as List<Object>);
          break;
      }
    }

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
                for (MapEntry m in (element['activities'] as Map).entries)
                  Activity(activity: m.key),
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
