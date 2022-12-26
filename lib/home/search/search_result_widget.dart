import 'package:dima_project/constants.dart';
import 'package:dima_project/generated/l10n.dart';
import 'package:dima_project/home/search/offer_summary_page.dart';
import 'package:dima_project/model/offer.dart';
import 'package:dima_project/utils/utils.dart';
import 'package:dima_project/model/activities.dart' as internal_activity;
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class SearchResultWidget extends StatefulWidget {
  const SearchResultWidget({
    required this.offer,
    required this.position,
    super.key,
  });

  final Offer offer;
  final LatLng? position;

  @override
  State<SearchResultWidget> createState() => _SearchResultWidgetState();
}

class _SearchResultWidgetState extends State<SearchResultWidget> {
  bool isShowActivities = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(spaceBetweenWidgets / 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(spaceBetweenWidgets / 2),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => OfferSummaryPage(
                    offer: widget.offer,
                  ),
                ),
              ),
              child: Container(
                decoration: const BoxDecoration(color: Colors.transparent),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                              widget.offer.user!.name!,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 25.0,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '\$${widget.offer.price}',
                          style: const TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.w600,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: spaceBetweenWidgets,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_month_outlined),
                              const SizedBox(
                                width: spaceBetweenWidgets,
                              ),
                              Text(
                                printDate(widget.offer.startDate!),
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              const Icon(Icons.access_time),
                              const SizedBox(
                                width: spaceBetweenWidgets,
                              ),
                              Text(
                                printTime(widget.offer.startDate!),
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: spaceBetweenWidgets / 2,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              const Icon(Icons.timer_outlined),
                              const SizedBox(
                                width: spaceBetweenWidgets,
                              ),
                              Text(
                                printDuration(widget.offer.duration!),
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              const Icon(Icons.location_on_outlined),
                              const SizedBox(
                                width: spaceBetweenWidgets,
                              ),
                              if (widget.position != null)
                                Text(
                                  '${(distanceInMeters(widget.position!, widget.offer.position!) / 1000).toStringAsFixed(2)}${S.of(context).km}',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Divider(),
            GestureDetector(
              onTap: () {
                setState(() {
                  isShowActivities = !isShowActivities;
                });
              },
              child: Container(
                decoration: const BoxDecoration(color: Colors.transparent),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    isShowActivities
                        ? Column(
                            children: widget.offer.activities!.map<Widget>((e) {

                              String name = e.activity;

                              for (internal_activity.Activity activity in defaultActivities){
                                if(activity.value == e.activity){
                                  name = activity.name(context);
                                }
                              }

                              return Padding(
                                padding: EdgeInsets.only(
                                    bottom: widget.offer.activities!.last == e
                                        ? 0
                                        : spaceBetweenWidgets / 2),
                                child: Row(
                                  children: [
                                    const Text(
                                      '\u2022',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: spaceBetweenWidgets,
                                    ),
                                    Text(
                                      name,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          )
                        : Row(
                            children: [
                              const Icon(Icons.local_activity_outlined),
                              const SizedBox(
                                width: spaceBetweenWidgets,
                              ),
                              Text(
                                isShowActivities
                                    ? S.of(context).hideActivities
                                    : S.of(context).showActivities,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                    Icon(isShowActivities
                        ? Icons.arrow_drop_up
                        : Icons.arrow_drop_down),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
