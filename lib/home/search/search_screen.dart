import 'dart:async';

import 'package:dima_project/bloc/location_bloc.dart';
import 'package:dima_project/bloc/offer_bloc.dart';
import 'package:dima_project/constants.dart';
import 'package:dima_project/custom_widgets/app_bar.dart';
import 'package:dima_project/generated/l10n.dart';
import 'package:dima_project/home/search/search_phone_screen.dart';
import 'package:dima_project/home/search/search_tablet_screen.dart';
import 'package:dima_project/input/selection/selection_element.dart';
import 'package:dima_project/model/offer.dart';
import 'package:dima_project/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  LatLng? position;
  List<SelectionElement<String>>? activities;

  double priceValue = 100;

  List<Offer> offers = [];

  @override
  void initState() {
    super.initState();
    _positionHandler();
  }

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    activities ??= defaultActivities
        .map(
          (e) => SelectionElement<String>(
            name: e.name(context),
            selected: false,
            element: e.value,
          ),
        )
        .toList();
  }

  _positionHandler() async {
    LocationBloc locationBloc = context.read<LocationBloc>();
    Location? location;

    location = await locationBloc.state.location;

    if (location == null) {
      return;
    }

    LatLng position = locationDataToLatLng(await location.getLocation());

    setState(() {
      this.position = position;
    });
  }

  Future<void> onRefresh() {
    Completer completer = Completer();
    context.read<OfferBloc>().add(LoadEvent(
          completer: completer,
        ));
    return completer.future;
  }

  onChangeActivity(int change) {
    setState(() {
      activities![change].selected = !activities![change].selected;
    });
  }

  addOtherActivity(SelectionElement<String> selectionElement) {
    setState(() {
      activities = [
        ...activities!,
        selectionElement,
      ];
    });
  }

  onChangePriceValue(double priceValue) {
    setState(() {
      this.priceValue = priceValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: KAppBar(
        text: S.of(context).search,
      ),
      body: Center(child: BlocBuilder<OfferBloc, OfferState>(
        builder: (BuildContext context, OfferState state) {
          List<Offer> offers = state.offers.where((offer) {
            for (String activity in activities!
                .where((element) => element.selected)
                .map((e) => e.element!)) {
              if (!offer.activities!
                  .map((e) => e.activity)
                  .contains(activity)) {
                return false;
              }
            }

            if (offer.price! > priceValue) {
              return false;
            }

            return true;
          }).toList();

          if (isTablet(context)) {
            return SearchTabletScreen(
              position: position,
              activities: activities!,
              addOtherActivity: addOtherActivity,
              onChangeActivity: onChangeActivity,
              onRefresh: onRefresh,
              priceValue: priceValue,
              onChangePriceValue: onChangePriceValue,
              offers: offers,
            );
          } else {
            return SearchPhoneScreen(
              position: position,
              activities: activities!,
              addOtherActivity: addOtherActivity,
              onChangeActivity: onChangeActivity,
              onRefresh: onRefresh,
              priceValue: priceValue,
              onChangePriceValue: onChangePriceValue,
              offers: offers,
            );
          }
        },
      )),
    );
  }
}
