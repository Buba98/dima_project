import 'package:dima_project/bloc/location_bloc.dart';
import 'package:dima_project/bloc/offer_bloc.dart';
import 'package:dima_project/constants.dart';
import 'package:dima_project/home/search/search_phone_screen.dart';
import 'package:dima_project/home/search/search_tablet_screen.dart';
import 'package:dima_project/input/selection/selection_element.dart';
import 'package:dima_project/model/offer.dart';
import 'package:dima_project/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  List<SelectionElement> activities = defaultActivities
      .map((e) => SelectionElement(name: e, selected: false))
      .toList();

  double priceValue = 100;
  double distanceValue = 2000;

  List<Offer> offers = [];

  @override
  void initState() {
    _positionHandler();
    super.initState();
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

  onChangeActivity(int change) {
    setState(() {
      activities[change].selected = !activities[change].selected;
    });
  }

  addOtherActivity(SelectionElement selectionElement) {
    setState(() {
      activities = [
        ...activities,
        selectionElement,
      ];
    });
  }

  onChangePriceValue(double priceValue) {
    setState(() {
      this.priceValue = priceValue;
    });
  }

  onChangeDistanceValue(double distanceValue) {
    setState(() {
      this.distanceValue = distanceValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OfferBloc, OfferState>(
      builder: (BuildContext context, OfferState state) {
        List<Offer> offers = state.offers.where((offer) {
          for (String activity in activities
              .where((element) => element.selected)
              .map((e) => e.name)) {
            if (!offer.activities!.map((e) => e.activity).contains(activity)) {
              return false;
            }
          }

          if (priceValue != 100 &&
              priceValue != 0 &&
              offer.price! > priceValue) {
            return false;
          }

          if (position != null) {
            if (distanceValue != 2000 &&
                distanceValue != 0 &&
                distanceInMeters(position!, offer.position!) > distanceValue) {
              return false;
            }
          }

          if (offer.user!.uid == FirebaseAuth.instance.currentUser!.uid) {
            return false;
          }

          return true;
        }).toList();

        if (isTablet(context)) {
          return SearchTabletScreen(
            position: position,
            activities: activities,
            addOtherActivity: addOtherActivity,
            onChangeActivity: onChangeActivity,
            priceValue: priceValue,
            onChangePriceValue: onChangePriceValue,
            offers: offers,
            distanceValue: distanceValue,
            onChangeDistanceValue: onChangeDistanceValue,
          );
        } else {
          return SearchPhoneScreen(
            position: position,
            activities: activities,
            addOtherActivity: addOtherActivity,
            onChangeActivity: onChangeActivity,
            priceValue: priceValue,
            onChangePriceValue: onChangePriceValue,
            offers: offers,
            distanceValue: distanceValue,
            onChangeDistanceValue: onChangeDistanceValue,
          );
        }
      },
    );
  }
}
