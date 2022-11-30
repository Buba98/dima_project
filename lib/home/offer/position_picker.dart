import 'dart:async';

import 'package:dima_project/bloc/location_bloc.dart';
import 'package:dima_project/constants.dart';
import 'package:dima_project/input/button.dart';
import 'package:dima_project/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class PositionPicker extends StatefulWidget {
  const PositionPicker({
    super.key,
    this.position,
    required this.onBack,
    required this.onComplete,
  });

  final LatLng? position;
  final Function(LatLng) onBack;
  final Function(LatLng) onComplete;

  @override
  State<PositionPicker> createState() => _PositionPickerState();
}

class _PositionPickerState extends State<PositionPicker> {
  LatLng? position;
  LatLng? livePosition;
  StreamSubscription? streamSubscription;

  @override
  void initState() {
    position = widget.position;
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

    streamSubscription = location.onLocationChanged.listen((LocationData event) {
      setState(() {
        livePosition = locationDataToLatLng(event);
      });
    });
  }

  @override
  void dispose() {
    streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: FlutterMap(
            options: MapOptions(
              center: polimi,
              zoom: 15,
              maxZoom: 19,
              minZoom: 3,
              onTap: (_, position) => setState(() => this.position = position),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              ),
              MarkerLayer(
                rotate: true,
                markers: [
                  if (position != null)
                    Marker(
                      width: 50,
                      height: 50,
                      point: position!,
                      builder: (ctx) => const Icon(
                        Icons.location_searching,
                        size: 50,
                      ),
                    ),
                  if (livePosition != null)
                    Marker(
                      width: 30,
                      height: 30,
                      point: livePosition!,
                      builder: (ctx) => Container(
                        decoration: BoxDecoration(
                            color: Colors.lightBlue,
                            border: Border.all(color: Colors.blue, width: 3),
                            borderRadius: BorderRadius.circular(40)),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(
          height: spaceBetweenWidgets,
        ),
        Row(
          children: [
            Expanded(
              child: Button(
                primary: false,
                onPressed: () {
                  if (position == null) {
                    return;
                  }
                  widget.onBack(position!);
                },
                text: 'Back',
              ),
            ),
            const SizedBox(
              width: spaceBetweenWidgets,
            ),
            Expanded(
              child: Button(
                onPressed: () {
                  if (position == null) {
                    return;
                  }
                  widget.onComplete(position!);
                },
                text: 'Complete',
              ),
            ),
          ],
        ),
      ],
    );
  }
}
