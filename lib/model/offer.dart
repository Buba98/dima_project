import 'package:dima_project/model/internal_user.dart';
import 'package:latlong2/latlong.dart';

class Offer {
  String id;
  DateTime? startDate;
  Duration? duration;
  double? price;
  List<Activity>? activities;
  LatLng? position;
  InternalUser? user;
  bool fetched;

  Offer({
    required this.id,
    this.startDate,
    this.duration,
    this.price,
    this.activities,
    this.position,
    this.user,
    required this.fetched,
  });
}

class Activity {
  String activity;

  Activity({required this.activity});
}
