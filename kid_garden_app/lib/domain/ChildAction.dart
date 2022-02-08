import 'package:kid_garden_app/domain/Action.dart';

import 'Media.dart';
import 'User.dart';

class ChildAction {
  String id;
  DateTime? date;

  String actionGroupId;
  ActionGroup actionGroup;
  String? value;

  User? user;

  List<Media>? medias;

  Audience? audience;

  ChildAction({required this.id, this.date,
    required this.actionGroupId,
      this.value, this.user,
      this.medias, this.audience,required this.actionGroup});
}

enum Audience { All, Parents, Staff, OnlyMe }
