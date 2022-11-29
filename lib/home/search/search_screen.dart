import 'dart:async';

import 'package:dima_project/constants/constants.dart';
import 'package:dima_project/custom_widgets/app_bar.dart';
import 'package:dima_project/home/offer/offer_bloc.dart';
import 'package:dima_project/home/search/search_result_widget.dart';
import 'package:dima_project/input/button.dart';
import 'package:dima_project/input/selection/selection.dart';
import 'package:dima_project/input/selection/selection_element.dart';
import 'package:dima_project/input/text_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const KAppBar(
        text: 'Search',
      ),
      body: Center(
          child: MediaQuery.of(context).size.shortestSide < tabletThreshold
              ? const _SearchScreenPhone()
              : const _SearchScreenTablet()),
    );
  }
}

class _SearchScreenPhone extends StatefulWidget {
  const _SearchScreenPhone({Key? key}) : super(key: key);

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
          const Expanded(
            child: _OffersView(),
          ),
        ],
      ),
    );
  }
}

class _SearchScreenTablet extends StatefulWidget {
  const _SearchScreenTablet({Key? key}) : super(key: key);

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
            padding: EdgeInsets.only(
              left: spaceBetweenWidgets,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Filter'),
                    SizedBox(
                      width: spaceBetweenWidgets,
                    ),
                    const Icon(Icons.filter_list_sharp),
                  ],
                ),
                SizedBox(
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
                    SizedBox(
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
        SizedBox(
          width: spaceBetweenWidgets,
        ),
        Expanded(
          flex: 7,
          child: Padding(
            padding: EdgeInsets.only(right: spaceBetweenWidgets),
            child: const _OffersView(),
          ),
        ),
      ],
    );
  }
}

class _OffersView extends StatelessWidget {
  const _OffersView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      strokeWidth: 3.0,
      child: BlocBuilder<OfferBloc, OfferState>(
        builder: (BuildContext context, OfferState state) {
          return ListView.builder(
            itemCount: state.offers.length,
            itemBuilder: (BuildContext context, int index) {
              return SearchResultWidget(
                offer: state.offers[index],
              );
            },
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
