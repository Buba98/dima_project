import 'dart:async';

import 'package:dima_project/bloc/location_bloc.dart';
import 'package:dima_project/constants.dart';
import 'package:dima_project/custom_widgets/app_bar.dart';
import 'package:dima_project/bloc/offer_bloc.dart';
import 'package:dima_project/home/search/search_result_widget.dart';
import 'package:dima_project/input/button.dart';
import 'package:dima_project/input/selection/selection.dart';
import 'package:dima_project/input/selection/selection_element.dart';
import 'package:dima_project/input/text_input.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const KAppBar(
        text: 'Search',
      ),
      body: Center(
        child: isTablet(context)
            ? _SearchScreenTablet(
                position: position,
              )
            : _SearchScreenPhone(
                position: position,
              ),
      ),
    );
  }
}

class _SearchScreenPhone extends StatefulWidget {
  const _SearchScreenPhone({
    Key? key,
    required this.position,
  }) : super(key: key);

  final LatLng? position;

  @override
  State<_SearchScreenPhone> createState() => _SearchScreenPhoneState();
}

class _SearchScreenPhoneState extends State<_SearchScreenPhone> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: spaceBetweenWidgets),
      child: Column(
        children: [
          Button(onPressed: () {}, text: 'Filter'),
          SizedBox(
            height: spaceBetweenWidgets,
          ),
          Expanded(
            child: _OffersView(
              position: widget.position,
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchScreenTablet extends StatefulWidget {
  const _SearchScreenTablet({
    Key? key,
    required this.position,
  }) : super(key: key);

  final LatLng? position;

  @override
  State<_SearchScreenTablet> createState() => _SearchScreenTabletState();
}

class _SearchScreenTabletState extends State<_SearchScreenTablet> {
  List<SelectionElement> activities = defaultActivities
      .map((e) => SelectionElement(name: e, selected: false))
      .toList();

  TextEditingController otherActivity = TextEditingController();

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
                Selection(
                  onChanged: (int change) {
                    setState(() {
                      activities[change].selected =
                          !activities[change].selected;
                    });
                  },
                  elements: activities,
                ),
                const Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: TextInput(
                        textEditingController: otherActivity,
                      ),
                    ),
                    const SizedBox(
                      width: spaceBetweenWidgets,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (otherActivity.text.isEmpty) {
                          return;
                        }

                        for (SelectionElement activity in activities) {
                          if (activity.name == otherActivity.text) {
                            otherActivity.clear();
                            return;
                          }
                        }

                        setState(() {
                          activities = [
                            ...activities,
                            SelectionElement(
                                name: otherActivity.text, selected: true)
                          ];
                        });

                        otherActivity.clear();
                      },
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50)),
                        child: const Icon(
                          Icons.add,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
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
            child: _OffersView(
              position: widget.position,
            ),
          ),
        ),
      ],
    );
  }
}

class _OffersView extends StatelessWidget {
  const _OffersView({
    Key? key,
    required this.position,
  }) : super(key: key);

  final LatLng? position;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      strokeWidth: 3.0,
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
            separatorBuilder: (BuildContext context, int index) => SizedBox(
              height: spaceBetweenWidgets,
            ),
          );
        },
      ),
      onRefresh: () {
        Completer completer = Completer();
        context.read<OfferBloc>().add(LoadEvent(completer: completer));
        return completer.future;
      },
    );
  }
}
