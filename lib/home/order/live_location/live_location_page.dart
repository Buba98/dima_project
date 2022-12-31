import 'package:dima_project/constants.dart';
import 'package:dima_project/custom_widgets/app_bar.dart';
import 'package:dima_project/generated/l10n.dart';
import 'package:dima_project/home/order/live_location/live_location_bloc.dart';
import 'package:dima_project/model/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class LiveLocationPage extends StatefulWidget {
  final Order order;

  const LiveLocationPage({
    super.key,
    required this.order,
  });

  @override
  State<LiveLocationPage> createState() => _LiveLocationPageState();
}

class _LiveLocationPageState extends State<LiveLocationPage> {
  final MapController mapController = MapController();
  LatLng? location;
  late final LiveLocationBloc liveLocationBloc;

  @override
  void initState() {
    liveLocationBloc = LiveLocationBloc(widget.order.offer);
    super.initState();
    liveLocationBloc.state.latLng.listen((LatLng? event) {
      setState(() {
        location = event;
      });
      if (event != null) {
        mapController.move(event, mapController.zoom);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: KAppBar(
        text: S.of(context).liveLocation,
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              center: location ?? polimi,
              zoom: 15,
              maxZoom: 19,
              minZoom: 3,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              ),
              MarkerLayer(
                rotate: true,
                markers: [
                  if (location != null)
                    Marker(
                      width: 30,
                      height: 30,
                      point: location!,
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
          if (location == null)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(spaceBetweenWidgets),
                child: Card(
                  color: Colors.white24,
                  child: Text(
                    S.of(context).liveLocationIsNotAvailable,
                    style: TextStyle(
                      color: Theme.of(context).errorColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
