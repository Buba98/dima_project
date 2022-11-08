import 'package:dima_project/constants/constants.dart';
import 'package:dima_project/input/selection/selection.dart';
import 'package:dima_project/input/selection/selection_element.dart';
import 'package:dima_project/input/text_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../custom_widgets/app_bar.dart';
import '../../input/button.dart';
import 'date_picker.dart';

class CreateOfferPage extends StatefulWidget {
  const CreateOfferPage({super.key});

  @override
  State<CreateOfferPage> createState() => _CreateOfferPageState();
}

class _CreateOfferPageState extends State<CreateOfferPage> {
  int index = 0;

  DateTime? startDate;
  DateTime? endDate;

  TextEditingController price = TextEditingController();

  List<SelectionElement> activities = List.from(Constants.activities
      .map((e) => SelectionElement(name: e, selected: false)));

  LatLng? position;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const KAppBar(
        text: 'Create offer',
      ),
      body: Padding(
        padding: EdgeInsets.all(Constants.spaceBetweenWidgets),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Column(
              children: [
                const Spacer(),
                if (constraints.maxWidth > Constants.tabletThreshold)
                  if (index == 0)
                    Row(
                      children: [
                        Expanded(
                          child: DateStartEndPricePicker(
                            onChangeStartDate: (DateTime picked) {
                              if (picked.isBefore(DateTime.now())) {
                                return;
                              }
                              setState(() => startDate = picked);
                            },
                            onChangeEndDate: (DateTime picked) {
                              if (picked
                                  .isBefore(startDate ?? DateTime.now())) {
                                return;
                              }
                              setState(() => endDate = picked);
                            },
                            startDate: startDate,
                            endDate: endDate,
                            price: price,
                          ),
                        ),
                        SizedBox(
                          width: Constants.spaceBetweenWidgets,
                        ),
                        Expanded(
                          child: ActivitiesPicker(
                            activities: activities,
                            onChange: (value) {
                              setState(() {
                                activities[value].selected =
                                    !activities[value].selected;
                              });
                            },
                            onAddOption: (String value) {
                              setState(
                                () => activities = [
                                  ...activities,
                                  SelectionElement(
                                    name: value,
                                    selected: true,
                                  )
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    )
                  else
                    PositionPicker(
                      position: position,
                      onTap: (LatLng newPosition) {
                        setState(() => position = newPosition);
                      },
                    )
                else if (index == 0)
                  DateStartEndPricePicker(
                    onChangeStartDate: (DateTime picked) {
                      if (picked.isBefore(DateTime.now())) {
                        return;
                      }
                      setState(() => startDate = picked);
                    },
                    onChangeEndDate: (DateTime picked) {
                      if (picked.isBefore(startDate ?? DateTime.now())) {
                        return;
                      }
                      setState(() => endDate = picked);
                    },
                    startDate: startDate,
                    endDate: endDate,
                    price: price,
                  )
                else if (index == 1)
                  ActivitiesPicker(
                    activities: activities,
                    onChange: (value) {
                      setState(() {
                        activities[value].selected =
                            !activities[value].selected;
                      });
                    },
                    onAddOption: (String value) {
                      setState(
                        () => activities = [
                          ...activities,
                          SelectionElement(
                            name: value,
                            selected: true,
                          )
                        ],
                      );
                    },
                  )
                else
                  PositionPicker(
                    position: position,
                    onTap: (LatLng newPosition) {
                      setState(() => position = newPosition);
                    },
                  ),
                const Spacer(),
                if (constraints.maxWidth > Constants.tabletThreshold)
                  Row(
                    children: [
                      if (index != 0)
                        Expanded(
                          child: Button(
                            onPressed: () => setState(() => index--),
                            text: 'Back',
                            primary: false,
                          ),
                        ),
                      if (index != 0)
                        SizedBox(
                          width: Constants.spaceBetweenWidgets,
                        ),
                      if (index != 1)
                        Expanded(
                          child: Button(
                            onPressed: () => setState(() => index++),
                            text: 'Next',
                          ),
                        ),
                      if (index != 0)
                        Expanded(
                          child: Button(
                            onPressed: () => setState(() => index++),
                            text: 'Complete',
                          ),
                        ),
                    ],
                  )
                else
                  Row(
                    children: [
                      if (index != 0)
                        Expanded(
                          child: Button(
                            onPressed: () => setState(() => index--),
                            text: 'Back',
                            primary: false,
                          ),
                        ),
                      if (index != 0)
                        SizedBox(
                          width: Constants.spaceBetweenWidgets,
                        ),
                      if (index != 2)
                        Expanded(
                          child: Button(
                            onPressed: () => setState(() => index++),
                            text: 'Next',
                          ),
                        ),
                      if (index == 2)
                        Expanded(
                          child: Button(
                            onPressed: () => setState(() => index++),
                            text: 'Complete',
                          ),
                        ),
                    ],
                  )
              ],
            );
          },
        ),
      ),
    );
  }
}

class PositionPicker extends StatelessWidget {
  const PositionPicker({
    super.key,
    this.position,
    required this.onTap,
  });

  final LatLng? position;
  final Function(LatLng) onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 12,
      child: FlutterMap(
        options: MapOptions(
          center: Constants.polimi,
          zoom: 15,
          maxZoom: 19,
          minZoom: 3,
          onTap: (_, position) => onTap(position),
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          ),
          if (position != null)
            MarkerLayer(
              rotate: true,
              markers: [
                Marker(
                  width: 80,
                  height: 80,
                  point: position!,
                  builder: (ctx) => const Icon(
                    Icons.where_to_vote,
                    size: 100,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class ActivitiesPicker extends StatelessWidget {
  ActivitiesPicker({
    super.key,
    required this.activities,
    required this.onChange,
    required this.onAddOption,
  });

  final List<SelectionElement> activities;
  final Function(int) onChange;
  final Function(String) onAddOption;
  final TextEditingController otherOption = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Selection(
              spacing: Constants.spaceBetweenWidgets,
              direction: Axis.horizontal,
              elementWidth:
                  (constraints.maxWidth - Constants.spaceBetweenWidgets) / 2,
              elements: activities,
              onChanged: onChange,
            );
          },
        ),
        SizedBox(
          height: Constants.spaceBetweenWidgets,
        ),
        Row(
          children: [
            Expanded(
              child: TextInput(
                icon: Icons.add,
                textEditingController: otherOption,
              ),
            ),
            SizedBox(
              width: Constants.spaceBetweenWidgets,
            ),
            GestureDetector(
              onTap: () {
                if (otherOption.text.isEmpty) {
                  return;
                }

                onAddOption(otherOption.text);
                otherOption.clear();
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
    );
  }
}

class DateStartEndPricePicker extends StatelessWidget {
  const DateStartEndPricePicker({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.onChangeStartDate,
    required this.onChangeEndDate,
    required this.price,
  });

  final DateTime? startDate;
  final DateTime? endDate;
  final Function(DateTime) onChangeStartDate;
  final Function(DateTime) onChangeEndDate;
  final TextEditingController price;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DatePicker(
            startDate: DateTime.now(),
            date: startDate,
            onChangeDate: onChangeStartDate),
        SizedBox(
          height: Constants.spaceBetweenWidgets,
        ),
        DatePicker(
          date: endDate,
          startDate: startDate,
          onChangeDate: onChangeEndDate,
        ),
        SizedBox(
          height: Constants.spaceBetweenWidgets,
        ),
        TextInput(
          textInputType: TextInputType.number,
          textEditingController: price,
          icon: Icons.attach_money,
        ),
      ],
    );
  }
}
