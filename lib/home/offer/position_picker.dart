import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../constants/constants.dart';
import '../../input/button.dart';

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

  @override
  void initState() {
    position = widget.position;
    super.initState();
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
              if (position != null)
                MarkerLayer(
                  rotate: true,
                  markers: [
                    Marker(
                      width: 80,
                      height: 80,
                      point: position!,
                      builder: (ctx) => const Icon(
                        Icons.location_searching,
                        size: 100,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
        SizedBox(
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
            SizedBox(
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
