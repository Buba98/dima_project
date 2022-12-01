import 'package:dima_project/constants.dart';
import 'package:dima_project/custom_widgets/app_bar.dart';
import 'package:dima_project/home/search/filter_view.dart';
import 'package:dima_project/home/search/offers_view.dart';
import 'package:dima_project/input/button.dart';
import 'package:dima_project/input/selection/selection_element.dart';
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
  }) : super(key: key);

  final LatLng? position;
  final Future<void> Function() onRefresh;

  final Function(SelectionElement) addOtherActivity;
  final List<SelectionElement> activities;
  final Function(int) onChangeActivity;

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
                  ),
                ),
              );
            },
            text: 'Filter',
          ),
          const SizedBox(
            height: spaceBetweenWidgets,
          ),
          Expanded(
            child: OffersView(
              position: position,
              onRefresh: onRefresh,
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
  }) : super(key: key);

  final Function(SelectionElement) addOtherActivity;
  final List<SelectionElement> activities;
  final Function(int) onChangeActivity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const KAppBar(
        text: 'Filters',
      ),
      body: Padding(
        padding: const EdgeInsets.all(spaceBetweenWidgets),
        child: FilterView(
          addOtherActivity: addOtherActivity,
          activities: activities,
          onChangeActivity: onChangeActivity,
        ),
      ),
    );
  }
}
