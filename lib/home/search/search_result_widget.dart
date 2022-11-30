import 'package:dima_project/constants.dart';
import 'package:dima_project/model/offer.dart';
import 'package:dima_project/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class SearchResultWidget extends StatelessWidget {
  const SearchResultWidget({
    required this.offer,
    required this.position,
    super.key,
  });

  final Offer offer;
  final LatLng? position;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(spaceBetweenWidgets / 2),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      offer.id,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                ),
                Text(
                  '€${offer.price}',
                  style: const TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF287762),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: spaceBetweenWidgets,
            ),
            Row(
              children: [
                const Icon(Icons.location_on_outlined),
                const SizedBox(
                  width: spaceBetweenWidgets,
                ),
                if (position != null)
                  Text(
                    '${(distanceInMeters(position!, offer.position!) / 1000).toStringAsFixed(2)} Km',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
              ],
            ),
            const SizedBox(
              height: spaceBetweenWidgets,
            ),
            Row(
              children: [
                const Icon(Icons.access_time),
                const SizedBox(
                  width: spaceBetweenWidgets,
                ),
                Text(
                  '${printDate(offer.startDate!)} for ${printDuration(offer.duration!)}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
