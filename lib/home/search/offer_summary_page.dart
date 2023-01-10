import 'dart:async';

import 'package:dima_project/bloc/location_bloc.dart';
import 'package:dima_project/bloc/offer_bloc.dart';
import 'package:dima_project/bloc/user/user_bloc.dart';
import 'package:dima_project/constants.dart';
import 'package:dima_project/custom_widgets/app_bar.dart';
import 'package:dima_project/generated/l10n.dart';
import 'package:dima_project/home/profile/profile_picture.dart';
import 'package:dima_project/input/button.dart';
import 'package:dima_project/input/selection/selection.dart';
import 'package:dima_project/input/selection/selection_element.dart';
import 'package:dima_project/input/show_text.dart';
import 'package:dima_project/model/dog.dart';
import 'package:dima_project/model/offer.dart';
import 'package:dima_project/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OfferSummaryPage extends StatelessWidget {
  const OfferSummaryPage({
    super.key,
    required this.offer,
  });

  final Offer offer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: KAppBar(
        text: S.of(context).offerSummary,
      ),
      body: OfferSummaryWidget(
        offer: offer,
      ),
    );
  }
}

class OfferSummaryWidget extends StatefulWidget {
  const OfferSummaryWidget({
    super.key,
    required this.offer,
  });

  final Offer offer;

  @override
  State<OfferSummaryWidget> createState() => _OfferSummaryWidgetState();
}

class _OfferSummaryWidgetState extends State<OfferSummaryWidget> {
  late final List<SelectionElement<Dog>> dogs;
  bool error = false;
  late final bool isMyOffer;

  @override
  void initState() {
    isMyOffer =
        widget.offer.user!.uid == FirebaseAuth.instance.currentUser!.uid;

    dogs = ((context.read<UserBloc>().state) as InitializedState)
        .internalUser
        .dogs!
        .map(
          (e) => SelectionElement<Dog>(
            name: e.name!,
            icon: e.sex! ? Icons.male : Icons.female,
            selected: false,
            element: e,
          ),
        )
        .toList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return isWide(constraints)
          ? _OfferSummaryTablet(
              offer: widget.offer,
              onComplete: onComplete,
              onSelectDog: onSelectDog,
              dogs: dogs,
              error: error,
              isMyOffer: isMyOffer,
              shareLiveLocation: shareLiveLocation,
            )
          : _OfferSummaryPhone(
              offer: widget.offer,
              onComplete: onComplete,
              onSelectDog: onSelectDog,
              dogs: dogs,
              error: error,
              isMyOffer: isMyOffer,
              shareLiveLocation: shareLiveLocation,
            );
    });
  }

  void shareLiveLocation() {
    context.read<LocationBloc>().add(ShareLocationEvent(offer: widget.offer));
    Navigator.pop(context);
  }

  void onComplete() {
    Completer completer = Completer();

    if (isMyOffer) {
      context
          .read<OfferBloc>()
          .add(DeleteOfferEvent(offer: widget.offer, completer: completer));
      Navigator.pop(context);

      return;
    }

    if (dogs.where((element) => element.selected).isEmpty) {
      completer.complete();
      setState(() {
        error = true;
      });
      return;
    }

    context.read<OfferBloc>().add(
          OrderEvent(
            dogs: dogs
                .where((element) => element.selected)
                .map((e) => e.element!)
                .toList(),
            offer: widget.offer,
            completer: completer,
          ),
        );
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
    required this.error,
    required this.isMyOffer,
    required this.shareLiveLocation,
  }) : super(key: key);

  final Offer offer;
  final Function() onComplete;
  final Function(int) onSelectDog;
  final List<SelectionElement> dogs;
  final bool error;
  final bool isMyOffer;
  final Function() shareLiveLocation;

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
                future: offer.user!.profilePicture,
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  return ProfilePicture(
                    radius: constraints.maxWidth / 8,
                    image: snapshot.connectionState == ConnectionState.done &&
                            snapshot.hasData
                        ? NetworkImage(snapshot.data!)
                        : null,
                  );
                },
              );
            },
          ),
          if (offer.user!.bio != null) ...[
            const SizedBox(
              height: spaceBetweenWidgets,
            ),
            ShowText(
              title: S.of(context).biography,
              text: offer.user!.bio!,
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
                  text: offer.user!.name!,
                ),
              ),
              const SizedBox(
                width: spaceBetweenWidgets,
              ),
              Expanded(
                child: ShowText(
                  title: S.of(context).location,
                  text: offer.location!,
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
            elements: offer.activities!.map((Activity activity) {
              String? name;

              for (Map<String, String> a in defaultActivities(context)) {
                if (a['value']! == activity.activity) {
                  name = a['name']!;
                  break;
                }
              }

              return SelectionElement(
                name: name ?? activity.activity,
                selected: true,
              );
            }).toList(),
            title: S.of(context).activities,
          ),
          const SizedBox(
            height: spaceBetweenWidgets,
          ),
          if (!isMyOffer) ...[
            Selection(
              elements: dogs,
              onChanged: onSelectDog,
              title: S.of(context).selectDogs,
              error: error,
              errorTitle: S.of(context).selectAtLeastADog,
            ),
            const SizedBox(
              height: spaceBetweenWidgets,
            ),
          ],
          Row(
            children: [
              if (isMyOffer) ...[
                Expanded(
                  child: Button(
                    disabled: DateTime.now().isBefore(offer.startDate!) ||
                            DateTime.now()
                                .isAfter(offer.startDate!.add(offer.duration!))
                        ? S.of(context).cantShareLocationYet
                        : null,
                    onPressed: shareLiveLocation,
                    text: S.of(context).shareLiveLocation,
                    primary: false,
                  ),
                ),
                const SizedBox(
                  width: spaceBetweenWidgets,
                ),
              ],
              Expanded(
                child: Button(
                  onPressed: onComplete,
                  text: isMyOffer
                      ? S.of(context).deleteOffer
                      : S.of(context).confirm,
                  attention: true,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: spaceBetweenWidgets,
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
    required this.error,
    required this.isMyOffer,
    required this.shareLiveLocation,
  }) : super(key: key);

  final Offer offer;
  final Function() onComplete;
  final Function(int) onSelectDog;
  final List<SelectionElement> dogs;
  final bool error;
  final bool isMyOffer;
  final Function() shareLiveLocation;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: spaceBetweenWidgets),
      child: ListView(
        children: [
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return FutureBuilder<String>(
                future: offer.user!.profilePicture,
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
          if (offer.user!.bio != null) ...[
            const SizedBox(
              height: spaceBetweenWidgets,
            ),
            ShowText(
              title: S.of(context).biography,
              text: offer.user!.bio!,
            ),
          ],
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
          ShowText(
            title: S.of(context).location,
            text: offer.location!,
          ),
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
            elements: offer.activities!.map((Activity activity) {
              String? name;

              for (Map<String, String> a in defaultActivities(context)) {
                if (a['value']! == activity.activity) {
                  name = a['name']!;
                  break;
                }
              }

              return SelectionElement(
                name: name ?? activity.activity,
                selected: true,
              );
            }).toList(),
            title: S.of(context).activities,
          ),
          const SizedBox(
            height: spaceBetweenWidgets,
          ),
          isMyOffer
              ? Button(
                  disabled: DateTime.now().isBefore(offer.startDate!) ||
                          DateTime.now()
                              .isAfter(offer.startDate!.add(offer.duration!))
                      ? S.of(context).cantShareLocationYet
                      : null,
                  onPressed: shareLiveLocation,
                  text: S.of(context).shareLiveLocation,
                  primary: false,
                )
              : Selection(
                  elements: dogs,
                  onChanged: onSelectDog,
                  title: S.of(context).selectDogs,
                  error: error,
                  errorTitle: S.of(context).selectAtLeastADog,
                ),
          const SizedBox(
            height: spaceBetweenWidgets,
          ),
          Button(
            onPressed: onComplete,
            text: isMyOffer ? S.of(context).deleteOffer : S.of(context).confirm,
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
