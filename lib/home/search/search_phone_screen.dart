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

class SearchPhoneScreen extends StatefulWidget {
  const SearchPhoneScreen({
    Key? key,
    required this.position,
    required this.addOtherActivity,
    required this.activities,
    required this.onChangeActivity,
    required this.priceValue,
    required this.onChangePriceValue,
    required this.offers,
    required this.distanceValue,
    required this.onChangeDistanceValue,
  }) : super(key: key);

  final LatLng? position;
  final List<SelectionElement<String>> activities;
  final Function(SelectionElement<String>) addOtherActivity;
  final Function(int change) onChangeActivity;
  final double priceValue;
  final double distanceValue;
  final Function(double) onChangePriceValue;
  final List<Offer> offers;
  final Function(double) onChangeDistanceValue;

  @override
  State<SearchPhoneScreen> createState() => _SearchPhoneScreenState();
}

class _SearchPhoneScreenState extends State<SearchPhoneScreen> {
  bool isFilterView = false;

  onChangeView() {
    setState(() {
      isFilterView = !isFilterView;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: KAppBar(
        text: isFilterView ? S.of(context).filter : S.of(context).search,
        backBehaviour: isFilterView ? onChangeView : null,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: spaceBetweenWidgets),
        child: isFilterView
            ? FilterView(
                addOtherActivity: widget.addOtherActivity,
                activities: widget.activities,
                onChangeActivity: widget.onChangeActivity,
                priceValue: widget.priceValue,
                onChangePriceValue: widget.onChangePriceValue,
                distanceValue: widget.distanceValue,
                onChangeDistanceValue: widget.onChangeDistanceValue,
              )
            : _SearchPhoneScreen(
                position: widget.position,
                offers: widget.offers,
                onChangeView: onChangeView,
              ),
      ),
    );
  }
}

class _SearchPhoneScreen extends StatelessWidget {
  const _SearchPhoneScreen({
    Key? key,
    required this.position,
    required this.offers,
    required this.onChangeView,
  }) : super(key: key);

  final LatLng? position;
  final List<Offer> offers;
  final Function() onChangeView;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Button(
          icon: Icons.filter_list,
          onPressed: onChangeView,
          text: S.of(context).filter,
        ),
        const SizedBox(
          height: spaceBetweenWidgets,
        ),
        Expanded(
          child: OffersView(
            position: position,
            offers: offers,
          ),
        ),
      ],
    );
  }
}
