import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dima_project/user/internal_user.dart';
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
  late Map<String, dynamic> firestoreModel;

  ModifyEvent({String? name})
      : firestoreModel = {
          'name': name,
        };
}

abstract class UserState {}

class InitializationState extends UserState {}

class NotInitializedState extends UserState {}

class InitializedState extends UserState {
  final InternalUser internalUser;

  InitializedState({
    required this.internalUser,
  });
}

class UserBloc extends Bloc<UserEvent, UserState> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  UserBloc() : super(InitializationState()) {
    on<_ReloadEvent>(_onReloadEvent);
    on<ModifyEvent>(_onModifyEvent);

    _firebaseFirestore
        .collection('users')
        .doc(_firebaseAuth.currentUser!.uid)
        .snapshots()
        .listen((DocumentSnapshot<Map<String, dynamic>> event) {
      add(_ReloadEvent(event: event));
    });
  }

  _onReloadEvent(_ReloadEvent event, Emitter<UserState> emit) {
    if (!event.event.exists || event.event.data()!['name'] == null) {
      emit(NotInitializedState());
      return;
    }

    Map<String, dynamic> data = event.event.data()!;

    InternalUser internalUser = InternalUser(
      uid: _firebaseAuth.currentUser!.uid,
      name: data['name'],
    );

    emit(InitializedState(internalUser: internalUser));
  }

  _onModifyEvent(ModifyEvent event, Emitter<UserState> emit) {
    _firebaseFirestore
        .collection('users')
        .doc(_firebaseAuth.currentUser!.uid)
        .set(event.firestoreModel, SetOptions(merge: true));
  }
}
