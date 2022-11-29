import 'package:dima_project/constants/constants.dart';
import 'package:dima_project/home/offer/offer_bloc.dart';
import 'package:dima_project/home/offer/position_picker.dart';
import 'package:dima_project/input/selection/selection_element.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';

import '../../custom_widgets/app_bar.dart';
import 'activities_picker.dart';
import 'date_start_end_price_picker.dart';

class CreateOfferPage extends StatefulWidget {
  const CreateOfferPage({super.key});

  @override
  State<CreateOfferPage> createState() => _CreateOfferPageState();
}

class _CreateOfferPageState extends State<CreateOfferPage> {
  int index = 0;

  DateTime? startDate;
  DateTime? endDate;

  double? price;

  List<SelectionElement>? activities;

  LatLng? position;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const KAppBar(
        text: 'Create offer',
      ),
      body: Padding(
        padding: EdgeInsets.all(spaceBetweenWidgets),
        child: index == 0
            ? DateStartEndPricePicker(
                onNext: (DateTime startDate, DateTime endDate, double price) =>
                    setState(() {
                  this.startDate = startDate;
                  this.endDate = endDate;
                  this.price = price;
                  index++;
                }),
                startDate: startDate,
                endDate: endDate,
                price: price,
              )
            : index == 1
                ? ActivitiesPicker(
                    activities: activities,
                    onNext: (List<SelectionElement> activities) => setState(() {
                      this.activities = activities;
                      index++;
                    }),
                    onBack: (List<SelectionElement> activities) => setState(() {
                      this.activities = activities;
                      index--;
                    }),
                  )
                : PositionPicker(
                    position: position,
                    onBack: (LatLng position) => setState(() {
                      this.position = position;
                      index--;
                    }),
                    onComplete: (LatLng position) {
                      setState(() {
                        this.position = position;
                      });
                      context.read<OfferBloc>().add(
                            AddOfferEvent(
                              startDate: startDate!,
                              endDate: endDate!,
                              price: price!,
                              activities: activities!
                                  .where((element) => element.selected)
                                  .map<String>((e) => e.name)
                                  .toList(),
                              position: this.position!,
                            ),
                          );
                      setState(() {
                        index = 0;
                        startDate = null;
                        endDate = null;
                        price = null;
                        activities = null;
                        this.position = null;
                      });
                    },
                  ),
      ),
    );
  }
}