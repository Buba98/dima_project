import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dima_project/model/dog.dart';
import 'package:dima_project/model/internal_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class UserEvent {}

class _ReloadEvent extends UserEvent {
  final DocumentSnapshot<Map<String, dynamic>> event;

  _ReloadEvent({
    required this.event,
  });
}

class ModifyEvent extends UserEvent {
  final Map<String, dynamic> firestoreModel;
  final File? image;

  ModifyEvent({
    String? name,
    this.image,
  }) : firestoreModel = {
          'name': name,
        };
}

class ModifyDogEvent extends UserEvent {
  final Map<String, dynamic> firestoreModel;

  ModifyDogEvent({required String name, required bool sex})
      : firestoreModel = {
          'name': name,
          'sex': sex,
        };
}

abstract class UserState {}

class InitializationState extends UserState {}

abstract class InitializedState extends UserState {
  final InternalUser internalUser;

  InitializedState({
    required this.internalUser,
  });
}

class NotInitializedState extends InitializedState {
  NotInitializedState({required super.internalUser});
}

class CompleteState extends InitializedState {
  CompleteState({required super.internalUser});
}

class UserBloc extends Bloc<UserEvent, UserState> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  UserBloc() : super(InitializationState()) {
    on<_ReloadEvent>(_onReloadEvent);
    on<ModifyEvent>(_onModifyEvent);
    on<ModifyDogEvent>(_onModifyDogEvent);

    _firebaseFirestore
        .collection('users')
        .doc(_firebaseAuth.currentUser!.uid)
        .snapshots()
        .listen((DocumentSnapshot<Map<String, dynamic>> event) {
      add(_ReloadEvent(event: event));
    });
  }

  _onModifyDogEvent(ModifyDogEvent event, Emitter<UserState> emit) async {
    event.firestoreModel['owner'] = _firebaseFirestore
        .collection('users')
        .doc(_firebaseAuth.currentUser!.uid);

    DocumentReference documentReference =
        await _firebaseFirestore.collection('dogs').add(event.firestoreModel);

    _firebaseFirestore
        .collection('users')
        .doc(_firebaseAuth.currentUser!.uid)
        .update({
      'dogs': FieldValue.arrayUnion([documentReference]),
    });
  }

  _onReloadEvent(_ReloadEvent event, Emitter<UserState> emit) {
    if (!event.event.exists || event.event.data()!['name'] == null) {
      emit(
        NotInitializedState(
          internalUser: InternalUser(
            uid: _firebaseAuth.currentUser!.uid,
            fetched: false,
          ),
        ),
      );
      return;
    }

    Map<String, dynamic> data = event.event.data()!;

    List<Dog> dogs = [];

    InternalUser internalUser = InternalUser(
      uid: _firebaseAuth.currentUser!.uid,
      name: data['name'],
      dogs: dogs,
      fetched: true,
    );

    if (data.containsKey('dogs')) {
      for (var doc in data['dogs']) {
        _firebaseFirestore
            .collection('dogs')
            .doc(doc.id)
            .get()
            .then((DocumentSnapshot dogDocument) {
          Map<String, dynamic> dogData =
              dogDocument.data()! as Map<String, dynamic>;
          dogs.add(
            Dog(
              uid: dogDocument.id,
              fetched: true,
              name: dogData['name'],
              sex: dogData['sex'],
              owner: internalUser,
            ),
          );
        });
      }
    }

    emit(CompleteState(internalUser: internalUser));
  }

  _onModifyEvent(ModifyEvent event, Emitter<UserState> emit) {
    _firebaseFirestore
        .collection('users')
        .doc(_firebaseAuth.currentUser!.uid)
        .set(event.firestoreModel, SetOptions(merge: true));

    if (event.image != null) {
      _firebaseStorage
          .ref(_firebaseAuth.currentUser!.uid)
          .child('profile.jpg')
          .putFile(event.image!);
    }
  }
}
