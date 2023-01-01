import 'package:dima_project/bloc/order_bloc.dart';
import 'package:dima_project/constants.dart';
import 'package:dima_project/custom_widgets/app_bar.dart';
import 'package:dima_project/generated/l10n.dart';
import 'package:dima_project/home/profile/profile_picture.dart';
import 'package:dima_project/input/button.dart';
import 'package:dima_project/input/selection/selection.dart';
import 'package:dima_project/input/selection/selection_element.dart';
import 'package:dima_project/input/show_text.dart';
import 'package:dima_project/model/offer.dart';
import 'package:dima_project/model/order.dart';
import 'package:dima_project/model/dog.dart';
import 'package:dima_project/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'live_location/live_location_page.dart';

class OrderSummaryPage extends StatefulWidget {
  const OrderSummaryPage({
    super.key,
    required this.order,
    required this.isClientMe,
  });

  final Order order;
  final bool isClientMe;

  @override
  State<OrderSummaryPage> createState() => _OrderSummaryPageState();
}

class _OrderSummaryPageState extends State<OrderSummaryPage> {
  late final List<SelectionElement<Dog>> dogs;

  void deleteOrder() {
    context.read<OrderBloc>().add(DeleteOrderEvent(order: widget.order));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: KAppBar(
        text: S.of(context).orderSummary,
      ),
      body: isTablet()
          ? _OrderSummaryTablet(
              order: widget.order,
              isClientMe: widget.isClientMe,
              deleteOrder: deleteOrder,
            )
          : _OrderSummaryPhone(
              order: widget.order,
              isClientMe: widget.isClientMe,
              deleteOrder: deleteOrder,
            ),
    );
  }
}

class _OrderSummaryTablet extends StatelessWidget {
  const _OrderSummaryTablet({
    Key? key,
    required this.order,
    required this.isClientMe,
    required this.deleteOrder,
  }) : super(key: key);

  final Order order;
  final bool isClientMe;
  final Function() deleteOrder;

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
                    ? order.offer.user!.profilePicture
                    : order.client.profilePicture,
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
          if ((!isClientMe && (order.client.bio != null)) ||
              (isClientMe && (order.offer.user!.bio != null))) ...[
            const SizedBox(
              height: spaceBetweenWidgets,
            ),
            ShowText(
              title: S.of(context).biography,
              text: isClientMe ? order.offer.user!.bio! : order.client.bio!,
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
                  text:
                      isClientMe ? order.offer.user!.name! : order.client.name!,
                ),
              ),
              const SizedBox(
                width: spaceBetweenWidgets,
              ),
              Expanded(
                child: ShowText(
                  title: S.of(context).location,
                  text: order.offer.location!,
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
                  text: order.offer.price!.toStringAsFixed(2),
                ),
              ),
              const SizedBox(
                width: spaceBetweenWidgets,
              ),
              Expanded(
                child: ShowText(
                  title: S.of(context).time,
                  text:
                      '${printDate(order.offer.startDate!)} - ${printTime(order.offer.startDate!)} ${S.of(context).fOr} ${printDuration(order.offer.duration!)}',
                ),
              ),
            ],
          ),
          const SizedBox(
            height: spaceBetweenWidgets,
          ),
          Selection(
            elements: order.offer.activities!.map((Activity activity) {
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
            rows: 3,
          ),
          const SizedBox(
            height: spaceBetweenWidgets,
          ),
          Selection(
            elements: [
              for (Dog dog in order.dogs)
                SelectionElement(name: dog.name!, selected: true)
            ],
            title: S.of(context).selectedDogs,
            rows: 3,
          ),
          const SizedBox(
            height: spaceBetweenWidgets,
          ),
          if (isClientMe) ...[
            Button(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => LiveLocationPage(
                    order: order,
                  ),
                ),
              ),
              text: S.of(context).viewLiveLocation,
              attention: true,
            ),
            const SizedBox(
              height: spaceBetweenWidgets,
            ),
          ],
          Button(
            onPressed: deleteOrder,
            text: S.of(context).deleteOrder,
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

class _OrderSummaryPhone extends StatelessWidget {
  const _OrderSummaryPhone({
    Key? key,
    required this.order,
    required this.isClientMe,
    required this.deleteOrder,
  }) : super(key: key);

  final Order order;
  final bool isClientMe;
  final Function() deleteOrder;

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
                    ? order.offer.user!.profilePicture
                    : order.client.profilePicture,
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
          if ((!isClientMe && (order.client.bio != null)) ||
              (isClientMe && (order.offer.user!.bio != null))) ...[
            const SizedBox(
              height: spaceBetweenWidgets,
            ),
            ShowText(
              title: S.of(context).biography,
              text: isClientMe ? order.offer.user!.bio! : order.client.bio!,
            ),
          ],
          const SizedBox(
            height: spaceBetweenWidgets,
          ),
          ShowText(
            title: S.of(context).name,
            text: isClientMe ? order.offer.user!.name! : order.client.name!,
          ),
          const SizedBox(
            height: spaceBetweenWidgets,
          ),
          ShowText(
            title: S.of(context).price,
            text: order.offer.price!.toStringAsFixed(2),
          ),
          const SizedBox(
            height: spaceBetweenWidgets,
          ),
          ShowText(
            title: S.of(context).location,
            text: order.offer.location!,
          ),
          const SizedBox(
            height: spaceBetweenWidgets,
          ),
          ShowText(
            title: S.of(context).time,
            text:
                '${printDate(order.offer.startDate!)} - ${printTime(order.offer.startDate!)} ${S.of(context).fOr} ${printDuration(order.offer.duration!)}',
          ),
          const SizedBox(
            height: spaceBetweenWidgets,
          ),
          Selection(
            elements: order.offer.activities!.map((Activity activity) {
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
          Selection(
            elements: [
              for (Dog dog in order.dogs)
                SelectionElement(name: dog.name!, selected: true)
            ],
            title: S.of(context).selectedDogs,
          ),
          const SizedBox(
            height: spaceBetweenWidgets,
          ),
          if (isClientMe) ...[
            Button(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => LiveLocationPage(
                    order: order,
                  ),
                ),
              ),
              text: S.of(context).viewLiveLocation,
              attention: true,
            ),
            const SizedBox(
              height: spaceBetweenWidgets,
            ),
          ],
          Button(
            onPressed: deleteOrder,
            text: S.of(context).deleteOrder,
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
