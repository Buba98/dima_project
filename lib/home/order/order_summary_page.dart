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
  const OrderSummaryPage({
    super.key,
    required this.chat,
    required this.isClientMe,
  });

  final Order chat;
  final bool isClientMe;

  @override
  State<OrderSummaryPage> createState() => _OrderSummaryPageState();
}

class _OrderSummaryPageState extends State<OrderSummaryPage> {
  late final List<SelectionElement<Dog>> dogs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: KAppBar(
        text: S.of(context).orderSummary,
      ),
      body: isTablet(context)
          ? _OrderSummaryTablet(
              chat: widget.chat,
              isClientMe: widget.isClientMe,
            )
          : _OrderSummaryPhone(
              chat: widget.chat,
              isClientMe: widget.isClientMe,
            ),
    );
  }
}

class _OrderSummaryTablet extends StatelessWidget {
  const _OrderSummaryTablet({
    Key? key,
    required this.chat,
    required this.isClientMe,
  }) : super(key: key);

  final Order chat;
  final bool isClientMe;

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
                future: isClientMe
                    ? chat.offer.user!.profilePicture
                    : chat.client.profilePicture,
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
          if ((!isClientMe && (chat.client.bio != null)) ||
              (isClientMe && (chat.offer.user!.bio != null))) ...[
            const SizedBox(
              height: spaceBetweenWidgets,
            ),
            ShowText(
              title: S.of(context).biography,
              text: isClientMe ? chat.offer.user!.bio! : chat.client.bio!,
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
                  text: isClientMe ? chat.offer.user!.name! : chat.client.name!,
                ),
              ),
              const SizedBox(
                width: spaceBetweenWidgets,
              ),
              Expanded(
                child: ShowText(
                  title: S.of(context).location,
                  text: chat.offer.location!,
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
    required this.isClientMe,
  }) : super(key: key);

  final Order chat;
  final bool isClientMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: spaceBetweenWidgets),
      child: ListView(
        children: [
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return FutureBuilder<String>(
                future: isClientMe
                    ? chat.offer.user!.profilePicture
                    : chat.client.profilePicture,
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
          if ((!isClientMe && (chat.client.bio != null)) ||
              (isClientMe && (chat.offer.user!.bio != null))) ...[
            const SizedBox(
              height: spaceBetweenWidgets,
            ),
            ShowText(
              title: S.of(context).biography,
              text: isClientMe ? chat.offer.user!.bio! : chat.client.bio!,
            ),
          ],
          const SizedBox(
            height: spaceBetweenWidgets,
          ),
          ShowText(
            title: S.of(context).name,
            text: isClientMe ? chat.offer.user!.name! : chat.client.name!,
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
          ShowText(
            title: S.of(context).location,
            text: chat.offer.location!,
          ),
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
