import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dima_project/model/offer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart';

abstract class LocationEvent {}

class InitializeEvent extends LocationEvent {}

class ShareLocationEvent extends LocationEvent {
  final Offer offer;

  ShareLocationEvent({
    required this.offer,
  });
}

class LocationState {
  final Location _location = Location.instance;

  Future<Location?> get location async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        return null;
      }
    }

    permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }
    return _location;
  }
}

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  Timer? timer;

  LocationBloc() : super(LocationState()) {
    on<ShareLocationEvent>(_onShareLocationEvent);
  }

  _onShareLocationEvent(ShareLocationEvent event, Emitter<LocationState> emit) {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('live_location')
        .doc(event.offer.id);

    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 30), (timer) async {
      LocationData locationData = await Location.instance.getLocation();

      documentReference.set({
        'latitude': locationData.latitude,
        'longitude': locationData.longitude,
      });

      if (DateTime.now()
          .isAfter(event.offer.startDate!.add(event.offer.duration!))) {
        timer.cancel();
      }
    });

    documentReference.delete();
  }
}
