import 'dart:async';

import 'package:dima_project/constants.dart';
import 'package:dima_project/home/search/search_result_card.dart';
import 'package:dima_project/model/offer.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class OffersView extends StatelessWidget {
  const OffersView({
    Key? key,
    required this.position,
    required this.offers,
  }) : super(key: key);

  final LatLng? position;
  final List<Offer> offers;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: offers.length,
      itemBuilder: (BuildContext context, int index) {
        return SearchResultCard(
          offer: offers[index],
          position: position,
        );
      },
      separatorBuilder: (BuildContext context, int index) => const SizedBox(
        height: spaceBetweenWidgets,
      ),
    );
  }
}
