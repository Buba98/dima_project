import 'package:dima_project/constants.dart';
import 'package:dima_project/generated/l10n.dart';
import 'package:dima_project/home/search/offer_summary_page.dart';
import 'package:dima_project/model/offer.dart';
import 'package:dima_project/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class SearchResultCard extends StatefulWidget {
  const SearchResultCard({
    required this.offer,
    required this.position,
    super.key,
  });

  final Offer offer;
  final LatLng? position;

  @override
  State<SearchResultCard> createState() => _SearchResultCardState();
}

class _SearchResultCardState extends State<SearchResultCard> {
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
                        Text(
                          widget.offer.user!.name!,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 25.0,
                          ),
                        ),
                        Text(
                          '\$${widget.offer.price!.toStringAsFixed(2)}',
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
                                width: spaceBetweenWidgets / 2,
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
                                width: spaceBetweenWidgets / 2,
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
                                width: spaceBetweenWidgets / 2,
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
                                width: spaceBetweenWidgets / 2,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      isShowActivities
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    const SizedBox(
                      width: spaceBetweenWidgets / 2,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                        if (isShowActivities)
                          const SizedBox(
                            height: spaceBetweenWidgets / 2,
                          ),
                        if (isShowActivities)
                          ...widget.offer.activities!
                              .map<Widget>((Activity activity) {
                            String? name;

                            for (Map<String, String> a
                                in defaultActivities(context)) {
                              if (a['value']! == activity.activity) {
                                name = a['name']!;
                                break;
                              }
                            }

                            return Padding(
                              padding: EdgeInsets.only(
                                  bottom:
                                      widget.offer.activities!.last == activity
                                          ? 0
                                          : spaceBetweenWidgets / 2),
                              child: Row(
                                children: [
                                  const Text(
                                    '\u2022',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: spaceBetweenWidgets / 2,
                                  ),
                                  Text(
                                    name ?? activity.activity,
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
                      ],
                    ),
                    const Spacer(),
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
