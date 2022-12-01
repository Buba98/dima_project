import 'dart:async';

import 'package:dima_project/bloc/location_bloc.dart';
import 'package:dima_project/bloc/offer_bloc.dart';
import 'package:dima_project/constants.dart';
import 'package:dima_project/custom_widgets/app_bar.dart';
import 'package:dima_project/home/search/search_phone_screen.dart';
import 'package:dima_project/home/search/search_tablet_screen.dart';
import 'package:dima_project/input/selection/selection_element.dart';
import 'package:dima_project/model/filter.dart';
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
  List<SelectionElement> activities = defaultActivities
      .map((e) => SelectionElement(name: e, selected: false))
      .toList();

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

  Future<void> onRefresh() {
    List<Filter> filters = [
      ...activities
          .where((element) => element.selected)
          .map<Filter>((e) => Filter(
                parameter: e.name,
                field: 'activities',
                filterType: FilterType.arrayContains,
              )),
    ];

    Completer completer = Completer();
    context.read<OfferBloc>().add(LoadEvent(
          completer: completer,
          filters: filters,
        ));
    return completer.future;
  }

  onChangeActivity(int change) {
    setState(() {
      activities[change].selected = !activities[change].selected;
    });
    onRefresh();
  }

  addOtherActivity(SelectionElement selectionElement) {
    setState(() {
      activities = [
        ...activities,
        selectionElement,
      ];
    });
    onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const KAppBar(
        text: 'Search',
      ),
      body: Center(
        child: isTablet(context)
            ? SearchTabletScreen(
                position: position,
                activities: activities,
                addOtherActivity: addOtherActivity,
                onChangeActivity: onChangeActivity,
                onRefresh: onRefresh,
              )
            : SearchPhoneScreen(
                position: position,
                activities: activities,
                addOtherActivity: addOtherActivity,
                onChangeActivity: onChangeActivity,
                onRefresh: onRefresh,
              ),
      ),
    );
  }
}
