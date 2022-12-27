import 'package:dima_project/model/dog.dart';
import 'package:dima_project/model/internal_user.dart';
import 'package:dima_project/model/offer.dart';

class Order {
  Order({
    required this.id,
    required this.offer,
    required this.client,
    required this.dogs,
  });

  final String id;
  final Offer offer;
  final InternalUser client;
  final List<Dog> dogs;
}
