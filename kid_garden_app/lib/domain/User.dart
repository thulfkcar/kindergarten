import 'package:kid_garden_app/domain/Action.dart';
import 'package:kid_garden_app/domain/Media.dart';

import 'Child.dart';

class User {
  String id;
  DateTime date;
  String name;

  String email;

  Media media;

  String role;

  List<ActionGroup> actions;

  List<Child> children;

  User(this.id, this.date, this.name, this.email, this.media, this.role,
      this.actions, this.children);
}
