import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class UserState {}

class InitializationState extends UserState {}

class UnauthenticatedState extends UserState {}

class AuthenticatedState extends UserState {}

abstract class UserEvent {}

class SignOutEvent extends UserEvent {}

class _ReloadEvent extends UserEvent {
  User? user;

  _ReloadEvent({required this.user});
}

///
/// Bloc don't like that a listener add yield a new state without being called
/// from an event
/// @see{https://stackoverflow.com/questions/71152302/flutter-bloc-emit-was-called-after-an-event-handler-completed-normally}
/// so every time a state changing action take place on the user we should add
/// a new event that will check what is the state of the user
///

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(InitializationState()) {
    on<SignOutEvent>((event, emit) => FirebaseAuth.instance.signOut());
    on<_ReloadEvent>(_onReloadEvent);

    FirebaseAuth.instance.userChanges().listen((User? user) {
      add(_ReloadEvent(user: user));
    });
  }

  _onReloadEvent(_ReloadEvent event, Emitter<UserState> emit) {
    if (event.user == null) {
      emit(UnauthenticatedState());
      return;
    }
    emit(AuthenticatedState());
  }
}
