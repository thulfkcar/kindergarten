import 'Child.dart';
import 'ChildAction.dart';
import 'Media.dart';
import 'User.dart';

class Child {
  String name;
  String id;
  String image;
  DateTime? date;
  Gender? gender;
  int? age;
  DateTime? birthDate;
  List<ChildAction>? childActions;
  Media? media;
  User? user;

  Child({required this.name, required this.id, required this.image, this.date, this.gender, this.age,
      this.birthDate, this.childActions, this.media, this.user});
}

enum Gender {
  Male,
  Female,
}
