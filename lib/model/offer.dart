import 'package:latlong2/latlong.dart';

class Offer {
  String id;
  DateTime? startDate;
  DateTime? endDate;
  double? price;
  List<Activity>? activities;
  LatLng? position;

  Offer({
    required this.id,
    this.startDate,
    this.endDate,
    this.price,
    this.activities,
    this.position,
  });
}

class Activity {
  String activity;

  Activity({required this.activity});
}
