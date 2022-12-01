import 'package:dima_project/constants.dart';
import 'package:dima_project/home/search/filter_view.dart';
import 'package:dima_project/home/search/offers_view.dart';
import 'package:dima_project/input/selection/selection_element.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class SearchTabletScreen extends StatelessWidget {
  const SearchTabletScreen({
    Key? key,
    required this.position,
    required this.activities,
    required this.addOtherActivity,
    required this.onChangeActivity,
    required this.onRefresh,
  }) : super(key: key);

  final LatLng? position;
  final List<SelectionElement> activities;
  final Function(SelectionElement) addOtherActivity;
  final Function(int change) onChangeActivity;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Padding(
            padding: const EdgeInsets.only(
              left: spaceBetweenWidgets,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('Filter'),
                    SizedBox(
                      width: spaceBetweenWidgets,
                    ),
                    Icon(Icons.filter_list_sharp),
                  ],
                ),
                const SizedBox(
                  height: spaceBetweenWidgets,
                ),
                Expanded(
                  child: FilterView(
                    addOtherActivity: addOtherActivity,
                    activities: activities,
                    onChangeActivity: onChangeActivity,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          width: spaceBetweenWidgets,
        ),
        Expanded(
          flex: 7,
          child: Padding(
            padding: const EdgeInsets.only(right: spaceBetweenWidgets),
            child: OffersView(
              position: position,
              onRefresh: onRefresh,
            ),
          ),
        ),
      ],
    );
  }
}
