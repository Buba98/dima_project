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

class DeleteDogEvent extends UserEvent {
  final String uid;

  DeleteDogEvent({required this.uid});
}

class ModifyDogEvent extends UserEvent {
  final Map<String, dynamic> firestoreModel;
  final String? uid;

  ModifyDogEvent({
    required String name,
    required bool sex,
    this.uid,
  }) : firestoreModel = {
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
  UserBloc() : super(InitializationState()) {
    on<_ReloadEvent>(_onReloadEvent);
    on<ModifyEvent>(_onModifyEvent);
    on<ModifyDogEvent>(_onModifyDogEvent);
    on<DeleteDogEvent>(_onDeleteDogEvent);

    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .listen((DocumentSnapshot<Map<String, dynamic>> event) {
      add(_ReloadEvent(event: event));
    });
  }

  _onDeleteDogEvent(DeleteDogEvent event, Emitter<UserState> emit) {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('dogs').doc(event.uid);

    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'dogs': FieldValue.arrayRemove([documentReference]),
    });

    documentReference.delete();
  }

  _onModifyDogEvent(ModifyDogEvent event, Emitter<UserState> emit) async {
    event.firestoreModel['owner'] = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid);

    if (event.uid != null) {
      await FirebaseFirestore.instance
          .collection('dogs')
          .doc(event.uid)
          .update(event.firestoreModel);

      return;
    }
    DocumentReference documentReference = await FirebaseFirestore.instance
        .collection('dogs')
        .add(event.firestoreModel);

    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'dogs': FieldValue.arrayUnion([documentReference]),
    });
  }

  _onReloadEvent(_ReloadEvent event, Emitter<UserState> emit) async {
    if (!event.event.exists || event.event.data()!['name'] == null) {
      emit(
        NotInitializedState(
          internalUser: InternalUser(
            uid: FirebaseAuth.instance.currentUser!.uid,
            fetched: false,
          ),
        ),
      );
      return;
    }

    Map<String, dynamic> data = event.event.data()!;

    InternalUser internalUser = InternalUser(
      uid: FirebaseAuth.instance.currentUser!.uid,
      name: data['name'],
      dogs: [],
      fetched: true,
    );

    if (data.containsKey('dogs')) {
      for (var doc in data['dogs']) {
        await FirebaseFirestore.instance
            .collection('dogs')
            .doc(doc.id)
            .get()
            .then((DocumentSnapshot dogDocument) {
          Map<String, dynamic> dogData =
              dogDocument.data()! as Map<String, dynamic>;
          internalUser.dogs!.add(
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
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set(event.firestoreModel, SetOptions(merge: true));

    if (event.image != null) {
      FirebaseStorage.instance
          .ref(FirebaseAuth.instance.currentUser!.uid)
          .child('profile.jpg')
          .putFile(event.image!);
    }
  }
}
