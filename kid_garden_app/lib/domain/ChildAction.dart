import 'package:kid_garden_app/domain/Action.dart';

import 'Media.dart';
import 'User.dart';

class ChildAction {
  String id;
  DateTime? date;

  ActionGroup action;

  String? value;

  User? user;

  List<Media>? medias;

  Audience? audience;

  ChildAction({required this.id, this.date, required this.action, this.value, this.user,
      this.medias, this.audience});
}

enum Audience { All, Parents, Staff, OnlyMe }
