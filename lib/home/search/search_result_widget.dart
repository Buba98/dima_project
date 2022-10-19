import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SearchResultWidget extends StatelessWidget {
  final String name;

  // double stars;
  // bool favourites;
  final double price;
  final double distance;
  final DateTime startingTime;
  final Duration duration;

  const SearchResultWidget(
      {required this.name,
      // this.stars = 0.0,
      // this.favourites = false,
      required this.price,
      required this.distance,
      required this.startingTime,
      required this.duration,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.95,
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //profile photo, //TODO
                Container(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.1),
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width * 0.1,
                  decoration: const BoxDecoration(
                      color: Color(0xFFF5F6F9), shape: BoxShape.circle),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 30.0,
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
                Text(
                  'Price: $price €',
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                    'At $distance m from you',
                style: TextStyle(
                  fontSize: 15,
                ),),
                //when as 'Mon 17 Oct from 9:00 to 10:00'
                Text(
                    '${DateFormat('E').format(startingTime)} ${DateFormat('d MMM').format(startingTime)} '
                    'from ${DateFormat('H:m').format(startingTime)} '
                    'to ${DateFormat('H:m').format(startingTime.add(duration))}',
                style: TextStyle(
                  fontSize: 15,
                ),),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
