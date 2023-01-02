import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dima_project/model/offer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';

abstract class LiveLocationEvent {}

class LiveLocationState {
  final StreamController<LatLng?> _latLng;

  LiveLocationState(
    this._latLng,
  );

  Stream<LatLng?> get latLng => _latLng.stream;
}

class LiveLocationBloc extends Bloc<LiveLocationEvent, LiveLocationState> {
  LiveLocationBloc(Offer offer)
      : super(LiveLocationState(StreamController<LatLng?>())) {
    FirebaseFirestore.instance
        .collection('live_location')
        .doc(offer.id)
        .snapshots()
        .listen((DocumentSnapshot<Map> documentSnapshot) {
      if (!documentSnapshot.exists) {
        state._latLng.add(null);
        return;
      }

      state._latLng.add(LatLng(
        documentSnapshot['latitude'],
        documentSnapshot['longitude'],
      ));
    });
  }
}
