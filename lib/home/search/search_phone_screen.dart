import 'package:dima_project/constants.dart';
import 'package:dima_project/custom_widgets/app_bar.dart';
import 'package:dima_project/generated/l10n.dart';
import 'package:dima_project/home/search/filter_view.dart';
import 'package:dima_project/home/search/offers_view.dart';
import 'package:dima_project/input/button.dart';
import 'package:dima_project/input/selection/selection_element.dart';
import 'package:dima_project/model/offer.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class SearchPhoneScreen extends StatelessWidget {
  const SearchPhoneScreen({
    Key? key,
    required this.position,
    required this.onRefresh,
    required this.addOtherActivity,
    required this.activities,
    required this.onChangeActivity,
    required this.priceValue,
    required this.onChangePriceValue, required this.offers,
  }) : super(key: key);

  final LatLng? position;
  final Future<void> Function() onRefresh;

  final Function(SelectionElement<String>) addOtherActivity;
  final List<SelectionElement> activities;
  final Function(int) onChangeActivity;

  final double priceValue;
  final Function(double) onChangePriceValue;

  final List<Offer> offers;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: spaceBetweenWidgets),
      child: Column(
        children: [
          Button(
            icon: Icons.filter_list,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FilterScreen(
                    addOtherActivity: addOtherActivity,
                    activities: activities,
                    onChangeActivity: onChangeActivity,
                    priceValue: priceValue,
                    onChangePriceValue: onChangePriceValue,
                  ),
                ),
              );
            },
            text: S.of(context).filter,
          ),
          const SizedBox(
            height: spaceBetweenWidgets,
          ),
          Expanded(
            child: OffersView(
              position: position,
              onRefresh: onRefresh,
              offers: offers,
            ),
          ),
        ],
      ),
    );
  }
}

class FilterScreen extends StatelessWidget {
  const FilterScreen({
    Key? key,
    required this.addOtherActivity,
    required this.activities,
    required this.onChangeActivity,
    required this.priceValue,
    required this.onChangePriceValue,
  }) : super(key: key);

  final Function(SelectionElement<String>) addOtherActivity;
  final List<SelectionElement> activities;
  final Function(int) onChangeActivity;
  final double priceValue;
  final Function(double) onChangePriceValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: KAppBar(
        text: S.of(context).filter,
      ),
      body: Padding(
        padding: const EdgeInsets.all(spaceBetweenWidgets),
        child: FilterView(
          addOtherActivity: addOtherActivity,
          activities: activities,
          onChangeActivity: onChangeActivity,
          onChangePriceValue: onChangePriceValue,
          priceValue: priceValue,
        ),
      ),
    );
  }
}
