import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class SignUpEvent {}

class EmailPasswordSignUpEvent extends SignUpEvent {
  final String email;
  final String password;

  EmailPasswordSignUpEvent({
    required this.email,
    required this.password,
  });
}

abstract class SignUpState {}

class InitialState extends SignUpState {}

class UserAlreadyExistsState extends SignUpState {}

class WeekPasswordState extends SignUpState {}

class GenericErrorState extends SignUpState {}

class SignedUpState extends SignUpState {}

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(InitialState()) {
    on<EmailPasswordSignUpEvent>(_onEmailPasswordSignUpEvent);
  }

  _onEmailPasswordSignUpEvent(
      EmailPasswordSignUpEvent event, Emitter<SignUpState> emit) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        emit(WeekPasswordState());
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        emit(UserAlreadyExistsState());
      } else {
        emit(GenericErrorState());
      }
    } catch (e) {
      print(e);
      emit(GenericErrorState());
    }
  }
}
