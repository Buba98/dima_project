import 'package:dima_project/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

List<Map<String, String>> defaultActivities(BuildContext context) => [
      {
        'name': S.of(context).park,
        'value': 'park',
      },
      {
        'name': S.of(context).swim,
        'value': 'swim',
      },
      {
        'name': S.of(context).run,
        'value': 'run',
      },
      {
        'name': S.of(context).liveLocation,
        'value': 'live_location',
      },
    ];

const double spaceBetweenWidgets = 20;
final LatLng polimi = LatLng(45.47810857587293, 9.227247297082284);

const Color primaryColor = Color(0xFF287762);
const Color secondaryColor = Color(0xFFe5e1d5);
