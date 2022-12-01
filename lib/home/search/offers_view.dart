import 'dart:async';

import 'package:dima_project/bloc/offer_bloc.dart';
import 'package:dima_project/constants.dart';
import 'package:dima_project/home/search/search_result_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';

class OffersView extends StatelessWidget {
  const OffersView({
    Key? key,
    required this.position,
    required this.onRefresh,
  }) : super(key: key);

  final LatLng? position;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      strokeWidth: 3.0,
      onRefresh: onRefresh,
      child: BlocBuilder<OfferBloc, OfferState>(
        builder: (BuildContext context, OfferState state) {
          return ListView.separated(
            itemCount: state.offers.length,
            itemBuilder: (BuildContext context, int index) {
              return SearchResultWidget(
                offer: state.offers[index],
                position: position,
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const SizedBox(
              height: spaceBetweenWidgets,
            ),
          );
        },
      ),
    );
  }
}
