import 'package:dima_project/constants.dart';
import 'package:dima_project/custom_widgets/app_bar.dart';
import 'package:dima_project/generated/l10n.dart';
import 'package:dima_project/home/profile/profile_picture.dart';
import 'package:dima_project/input/selection/selection.dart';
import 'package:dima_project/input/selection/selection_element.dart';
import 'package:dima_project/input/show_text.dart';
import 'package:dima_project/model/order.dart';
import 'package:dima_project/model/dog.dart';
import 'package:dima_project/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:geocode/geocode.dart';

class OrderSummaryPage extends StatefulWidget {
  const OrderSummaryPage({super.key, required this.chat});

  final Order chat;

  @override
  State<OrderSummaryPage> createState() => _OrderSummaryPageState();
}

class _OrderSummaryPageState extends State<OrderSummaryPage> {
  late final List<SelectionElement<Dog>> dogs;
  String location = '';

  @override
  initState() {
    super.initState();

    init();
  }

  init() async {
    Address address = await GeoCode().reverseGeocoding(
        latitude: widget.chat.offer.position!.latitude,
        longitude: widget.chat.offer.position!.longitude);

    setState(() {
      location =
          '${address.streetAddress ?? ''} ${address.streetNumber ?? ''} ${address.city ?? ''}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: KAppBar(
        text: S.of(context).orderSummary,
      ),
      body: isTablet(context)
          ? _OrderSummaryTablet(
              chat: widget.chat,
              location: location,
            )
          : _OrderSummaryPhone(
              chat: widget.chat,
              location: location,
            ),
    );
  }
}

class _OrderSummaryTablet extends StatelessWidget {
  const _OrderSummaryTablet({
    Key? key,
    required this.chat,
    required this.location,
  }) : super(key: key);

  final Order chat;
  final String location;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: spaceBetweenWidgets,
      ),
      child: ListView(
        children: [
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return FutureBuilder<String>(
                future: chat.offer.user!.profilePicture,
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  return ProfilePicture(
                    radius: constraints.maxWidth / 6,
                    image: snapshot.connectionState == ConnectionState.done &&
                            snapshot.hasData
                        ? NetworkImage(snapshot.data!)
                        : null,
                  );
                },
              );
            },
          ),
          if (chat.offer.user!.bio != null) ...[
            const SizedBox(
              height: spaceBetweenWidgets,
            ),
            ShowText(
              title: S.of(context).biography,
              text: chat.offer.user!.bio!,
            ),
          ],
          const SizedBox(
            height: spaceBetweenWidgets,
          ),
          Row(
            children: [
              Expanded(
                child: ShowText(
                  title: S.of(context).name,
                  text: chat.offer.user!.name!,
                ),
              ),
              const SizedBox(
                width: spaceBetweenWidgets,
              ),
              Expanded(
                child: ShowText(
                  title: S.of(context).location,
                  text: location,
                ),
              )
            ],
          ),
          const SizedBox(
            height: spaceBetweenWidgets,
          ),
          Row(
            children: [
              Expanded(
                child: ShowText(
                  title: S.of(context).price,
                  text: chat.offer.price!.toStringAsFixed(2),
                ),
              ),
              const SizedBox(
                width: spaceBetweenWidgets,
              ),
              Expanded(
                child: ShowText(
                  title: S.of(context).time,
                  text:
                      '${printDate(chat.offer.startDate!)} - ${printTime(chat.offer.startDate!)} ${S.of(context).fOr} ${printDuration(chat.offer.duration!)}',
                ),
              ),
            ],
          ),
          const SizedBox(
            height: spaceBetweenWidgets,
          ),
          Selection(
            elements: chat.offer.activities!
                .map((e) => SelectionElement(name: e.activity, selected: true))
                .toList(),
            title: S.of(context).activities,
            rows: 3,
          ),
          const SizedBox(
            height: spaceBetweenWidgets,
          ),
          Selection(
            elements: [
              for (Dog dog in chat.dogs)
                SelectionElement(name: dog.name!, selected: true)
            ],
            title: S.of(context).selectedDogs,
            rows: 3,
          ),
          const SizedBox(
            height: spaceBetweenWidgets,
          ),
        ],
      ),
    );
  }
}

class _OrderSummaryPhone extends StatelessWidget {
  const _OrderSummaryPhone({
    Key? key,
    required this.chat,
    required this.location,
  }) : super(key: key);

  final Order chat;
  final String location;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: spaceBetweenWidgets),
      child: ListView(
        children: [
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return FutureBuilder<String>(
                future: chat.offer.user!.profilePicture,
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  return ProfilePicture(
                    radius: constraints.maxWidth / 4,
                    image: snapshot.connectionState == ConnectionState.done &&
                            snapshot.hasData
                        ? NetworkImage(snapshot.data!)
                        : null,
                  );
                },
              );
            },
          ),
          if (chat.offer.user!.bio != null) ...[
            const SizedBox(
              height: spaceBetweenWidgets,
            ),
            ShowText(
              title: S.of(context).biography,
              text: chat.offer.user!.bio!,
            ),
          ],
          const SizedBox(
            height: spaceBetweenWidgets,
          ),
          ShowText(
            title: S.of(context).name,
            text: chat.offer.user!.name!,
          ),
          const SizedBox(
            height: spaceBetweenWidgets,
          ),
          ShowText(
            title: S.of(context).price,
            text: chat.offer.price!.toStringAsFixed(2),
          ),
          const SizedBox(
            height: spaceBetweenWidgets,
          ),
          ShowText(title: S.of(context).location, text: location),
          const SizedBox(
            height: spaceBetweenWidgets,
          ),
          ShowText(
            title: S.of(context).time,
            text:
                '${printDate(chat.offer.startDate!)} - ${printTime(chat.offer.startDate!)} ${S.of(context).fOr} ${printDuration(chat.offer.duration!)}',
          ),
          const SizedBox(
            height: spaceBetweenWidgets,
          ),
          Selection(
            elements: chat.offer.activities!
                .map((e) => SelectionElement(name: e.activity, selected: true))
                .toList(),
            title: S.of(context).activities,
          ),
          const SizedBox(
            height: spaceBetweenWidgets,
          ),
          Selection(
            elements: [
              for (Dog dog in chat.dogs)
                SelectionElement(name: dog.name!, selected: true)
            ],
            title: S.of(context).selectedDogs,
          ),
          const SizedBox(
            height: spaceBetweenWidgets,
          ),
        ],
      ),
    );
  }
}
