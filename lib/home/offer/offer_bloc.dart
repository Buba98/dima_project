import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';

abstract class OfferEvent {}

class AddOfferEvent extends OfferEvent {
  final Map<String, dynamic> firestoreModel;

  AddOfferEvent({
    required DateTime startDate,
    required DateTime endDate,
    required double price,
    required List<String> activities,
    required LatLng position,
  }) : firestoreModel = {
          'start_date': Timestamp.fromDate(startDate),
          'end_date': Timestamp.fromDate(endDate),
          'price': price,
          'activities': activities,
          'position': [position.latitude, position.longitude],
        };
}

abstract class OfferState {}

class InitializedState extends OfferState {}

class OfferBloc extends Bloc<OfferEvent, OfferState> {
  OfferBloc() : super(InitializedState()) {
    on<AddOfferEvent>(_onAddOfferEvent);
  }

  _onAddOfferEvent(AddOfferEvent event, Emitter<OfferState> emit) async {
    event.firestoreModel['user'] = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid);

    await FirebaseFirestore.instance
        .collection('offers')
        .add(event.firestoreModel);
  }
}
