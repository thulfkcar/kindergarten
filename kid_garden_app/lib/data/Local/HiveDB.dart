import 'dart:io';

import 'package:hive/hive.dart';
import 'package:kid_garden_app/domain/UserModel.dart';
import 'package:path_provider/path_provider.dart';

class HiveDB {
  var _userBox;

  HiveDB._create() {}

  static Future<HiveDB> create() async {
    try {

      final component = HiveDB._create();
      await component._init();
      return component;
    } catch (e) {
      rethrow;
    }
  }

  _init() async {
    final directory = await getApplicationDocumentsDirectory();

    var path = directory.path;
    Hive.init(path);
    if(!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(UserModelAdapter());
      Hive.registerAdapter(RoleAdapter());
    }
    this._userBox = await Hive.openBox<UserModel>('user');
  }

  storeUser(UserModel? user) {
    if(user!=null) {
      _userBox.put('user', user);
    }else
      {
        this._userBox.delete('user');
      }
  }

  UserModel? getUser() {
    return this._userBox.get('user');
  }
}
