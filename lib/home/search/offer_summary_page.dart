import 'package:dima_project/bloc/user/user_bloc.dart';
import 'package:dima_project/constants.dart';
import 'package:dima_project/custom_widgets/app_bar.dart';
import 'package:dima_project/generated/l10n.dart';
import 'package:dima_project/input/button.dart';
import 'package:dima_project/input/selection/selection.dart';
import 'package:dima_project/input/selection/selection_element.dart';
import 'package:dima_project/input/show_text.dart';
import 'package:dima_project/model/offer.dart';
import 'package:dima_project/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocode/geocode.dart';

class OfferSummaryPage extends StatefulWidget {
  const OfferSummaryPage({super.key, required this.offer});

  final Offer offer;

  @override
  State<OfferSummaryPage> createState() => _OfferSummaryPageState();
}

class _OfferSummaryPageState extends State<OfferSummaryPage> {
  late final List<SelectionElement> dogs;
  String location = '';

  @override
  void initState() {
    dogs = ((context.read<UserBloc>().state) as InitializedState)
        .internalUser
        .dogs!
        .map(
          (e) => SelectionElement(name: e.name!, selected: false),
        )
        .toList();

    init();

    super.initState();
  }

  init() async {
    Address address = await GeoCode().reverseGeocoding(
        latitude: widget.offer.position!.latitude,
        longitude: widget.offer.position!.longitude);

    setState(() {
      location =
          '${address.streetAddress ?? ''} ${address.streetNumber ?? ''} ${address.city ?? ''}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const KAppBar(
        text: 'Offer summary',
      ),
      body: isTablet(context)
          ? _OfferSummaryTablet(
              offer: widget.offer,
              onComplete: onComplete,
              onSelectDog: onSelectDog,
              dogs: dogs,
              location: location,
            )
          : _OfferSummaryPhone(
              offer: widget.offer,
              onComplete: onComplete,
              onSelectDog: onSelectDog,
              dogs: dogs,
              location: location,
            ),
    );
  }

  void onComplete(BuildContext context) {
    Navigator.pop(context);
  }

  void onSelectDog(int index) {
    setState(() {
      dogs[index].selected = !dogs[index].selected;
    });
  }
}

class _OfferSummaryTablet extends StatelessWidget {
  const _OfferSummaryTablet({
    Key? key,
    required this.offer,
    required this.onComplete,
    required this.onSelectDog,
    required this.dogs,
    required this.location,
  }) : super(key: key);

  final Offer offer;
  final Function(BuildContext) onComplete;
  final Function(int) onSelectDog;
  final List<SelectionElement> dogs;
  final String location;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(
        spaceBetweenWidgets,
      ),
      child: ListView(
        children: [
          Row(
            children: [
              const Spacer(),
              Expanded(
                child: Image.asset('assets/images/yes.png'),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(
            height: spaceBetweenWidgets,
          ),
          Row(
            children: [
              Expanded(
                child: ShowText(
                  title: S.of(context).name,
                  text: offer.user!.name!,
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
                  text: offer.price!.toStringAsFixed(2),
                ),
              ),
              const SizedBox(
                width: spaceBetweenWidgets,
              ),
              Expanded(
                child: ShowText(
                  title: S.of(context).time,
                  text:
                      '${printDate(offer.startDate!)} - ${printTime(offer.startDate!)} ${S.of(context).fOr} ${printDuration(offer.duration!)}',
                ),
              ),
            ],
          ),
          const SizedBox(
            height: spaceBetweenWidgets,
          ),
          Selection(
            elements: dogs,
            onChanged: onSelectDog,
            title: S.of(context).selectDogs,
          ),
          const SizedBox(
            height: spaceBetweenWidgets,
          ),
          Button(
            onPressed: () => onComplete(context),
            text: S.of(context).confirm,
            attention: true,
          ),
        ],
      ),
    );
  }
}

class _OfferSummaryPhone extends StatelessWidget {
  const _OfferSummaryPhone({
    Key? key,
    required this.offer,
    required this.onComplete,
    required this.onSelectDog,
    required this.dogs,
    required this.location,
  }) : super(key: key);

  final Offer offer;
  final Function(BuildContext) onComplete;
  final Function(int) onSelectDog;
  final List<SelectionElement> dogs;
  final String location;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: spaceBetweenWidgets),
      child: ListView(
        children: [
          Image.asset('assets/images/yes.png'),
          const SizedBox(
            height: spaceBetweenWidgets,
          ),
          ShowText(
            title: S.of(context).name,
            text: offer.user!.name!,
          ),
          const SizedBox(
            height: spaceBetweenWidgets,
          ),
          ShowText(
            title: S.of(context).price,
            text: offer.price!.toStringAsFixed(2),
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
                '${printDate(offer.startDate!)} - ${printTime(offer.startDate!)} ${S.of(context).fOr} ${printDuration(offer.duration!)}',
          ),
          const SizedBox(
            height: spaceBetweenWidgets,
          ),
          Selection(
            elements: dogs,
            onChanged: onSelectDog,
            title: S.of(context).selectDogs,
          ),
          const SizedBox(
            height: spaceBetweenWidgets,
          ),
          Button(
            onPressed: () => onComplete(context),
            text: S.of(context).confirm,
            attention: true,
          ),
          const SizedBox(
            height: spaceBetweenWidgets,
          ),
        ],
      ),
    );
  }
}
