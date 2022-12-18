import 'dart:async';

import 'package:dima_project/model/offer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class OrderEvent {}

class ReplyEvent extends OrderEvent {
  final Offer offer;
  final Completer? completer;

  ReplyEvent({
    required this.offer,
    this.completer,
  });
}

abstract class OrderState {}

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc(super.initialState) {
    on<ReplyEvent>(_onReplyEvent);
  }

  _onReplyEvent(ReplyEvent event, Emitter<OrderState> emit){

  }
}
