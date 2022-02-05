
import 'Action.dart';
import 'Child.dart';
import 'ChildAction.dart';

class Media {
  String id;
  DateTime date;
  MediaType mediaType;
  Child? child;
  ChildAction? childAction;
  ActionGroup? action;

  Media(this.id, this.date, this.mediaType, this.child, this.childAction,
      this.action);
}

enum MediaType {
  Video,
  Image,
}
