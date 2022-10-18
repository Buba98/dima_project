import 'package:dima_project/model/internal_user.dart';

class Dog {
  final String uid;
  final String? name;
  final bool? sex;
  final InternalUser? owner;
  bool fetched;

  Dog({
    required this.uid,
    this.name,
    this.sex,
    required this.fetched,
    this.owner,
  });
}
