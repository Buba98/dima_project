import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class SignInEvent {}

class EmailPasswordSignInEvent extends SignInEvent {
  final String email;
  final String password;

  EmailPasswordSignInEvent({
    required this.email,
    required this.password,
  });
}

abstract class SignInState {}

class InitialState extends SignInState {}

class UserNotFoundState extends SignInState {}

class WrongPasswordState extends SignInState {}

class GenericErrorState extends SignInState {}

class SignedInState extends SignInState {}

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  SignInBloc() : super(InitialState()) {
    on<EmailPasswordSignInEvent>(_onEmailPasswordSignInEvent);
  }

  _onEmailPasswordSignInEvent(
      EmailPasswordSignInEvent event, Emitter<SignInState> emit) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: event.email, password: event.password);
      emit(SignedInState());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        emit(UserNotFoundState());
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        emit(WrongPasswordState());
      } else {
        print(e);
        emit(GenericErrorState());
      }
    } catch (e) {
      print(e);
      emit(GenericErrorState());
    }
  }
}
