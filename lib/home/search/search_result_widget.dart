import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../settings/profile_picture.dart';

class SearchResultWidget extends StatelessWidget {
  final String name;

  // double stars;
  // bool favourites;
  final String price;
  final String distance;
  final DateTime startingTime;
  final Duration duration;
  final Future<String> userProfileUrl;

  SearchResultWidget(
      {required this.name,
      // this.stars = 0.0,
      // this.favourites = false,
      required price,
      required distance,
      required this.startingTime,
      required this.duration,
      required this.userProfileUrl,
      super.key})
      : this.price =
            price.toString().replaceAll(RegExp(r"([.]+0+)(?!.*\d)"), ""),
        this.distance =
            distance.toString().replaceAll(RegExp(r"([.]+0+)(?!.*\d)"), "");

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.95,
      child: Card(
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Spacer(),
                // ProfilePicture(
                //   profilePictureUrl: userProfileUrl,
                // ),
                const SizedBox(
                  width: 15,
                ),
                Column(
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 32.0,
                      ),
                    ),
                    // Row(
                    //   children: [
                    //     Text('Reviews: $stars/5'), //TODO?
                    //     Text(favourites ? 'Saved' : 'Not saved'), //TODO?
                    //   ],
                    // ),
                  ],
                ),
                const Spacer(
                  flex: 3,
                ),
                Text(
                  '$price €/h',
                  style: const TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF287762),
                  ),
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(
              height: 7,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Spacer(),
                const Icon(Icons.location_on_outlined),
                Text(
                  ' $distance m',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
                const Spacer(
                  flex: 4,
                ),
                //'Mon 17 Oct from 9:00 to 10:00'
                const Icon(Icons.access_time),
                Text(
                  ' ${DateFormat('E').format(startingTime)} ${DateFormat('d').format(startingTime)} '
                  '${DateFormat('H:mm').format(startingTime)} '
                  '-${DateFormat('H:mm').format(startingTime.add(duration))}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
                Spacer(),
              ],
            ),
            const SizedBox(
              height: 15,
            )
          ],
        ),
      ),
    );
  }
}
