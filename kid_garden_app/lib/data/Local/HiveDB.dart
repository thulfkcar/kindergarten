import 'package:hive/hive.dart';
import 'package:kid_garden_app/domain/UserModel.dart';

class HiveDB {
  var _userBox;

  HiveDB._create() {}

  static Future<HiveDB> create() async {
    final component = HiveDB._create();
    await component._init();
    return component;
  }

  _init() async {
    Hive.registerAdapter(UserModelAdapter());
    this._userBox = await Hive.openBox<UserModel>('user');
  }

  storeUser(UserModel? user) {
    this._userBox.put('user', user);
  }

  UserModel? getUser() {
    return this._userBox.get('user');
  }

}