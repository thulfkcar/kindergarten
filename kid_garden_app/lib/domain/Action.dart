import 'dart:ffi';

import 'ChildAction.dart';
import 'Media.dart';

class ActionGroup {
  String id;
  DateTime date;
  String name;
  Media? media;
  Bool? active;
  String image;
  List<ChildAction>? childActions;
  List<String>? dropDown;
  ActionListType? actionListType;

  ActionGroup(
      {required this.image,
        required this.id,
      required this.date,
      required this.name,
      this.media,
      this.active,
      this.childActions,
      this.dropDown,
      this.actionListType});
}

enum ActionListType { DropDown, Static }
