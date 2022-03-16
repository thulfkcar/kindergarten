import 'package:kid_garden_app/data/network/FromData/StaffAddingForm.dart';
import 'package:kid_garden_app/domain/User.dart';
import 'package:tuple/tuple.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../data/network/BaseApiService.dart';
import '../data/network/NetworkApiService.dart';
import '../data/network/models/ErrorResponse.dart';
import '../data/network/models/MultiResponse.dart';
import '../data/network/models/SingleResponse.dart';
import '../domain/Child.dart';

class UserRepository {
  final BaseApiService _apiService = NetworkApiService();

  Future<User> adduser({required StaffAddingForm staffAddingForm}) async {
    try {
      Map<String, String> jsonBody = Map();
      jsonBody.addAll({
        "Name": staffAddingForm.name.toString(),
        "Password": staffAddingForm.password.toString(),
        "Email": staffAddingForm.email.toString(),
        "Role": 'staff',
      });
      List<AssetEntity>? assest;
      if (staffAddingForm.image != null) {
        assest = [staffAddingForm.image!];
      }
      dynamic response =
          await _apiService.multiPartPostResponse("user/add", jsonBody, assest);

      var user;
      SingleResponse<User>.fromJson(await response, (json) {
        user = User.fromJson(json as Map<String, dynamic>);
        return user;
      });
      return await user;
    } catch (e) {
      if (e is ErrorResponse) {
        throw e.errorMsg.toString();
      }
      rethrow;
    }
  }




  Future<Tuple2<List<User>, bool>> getMyStaffList({required int page}) async {
    try {
      dynamic response = await _apiService.getResponse("User/getAll/$page");
      bool isLastPage = false;

      var staffs;
      var mainResponse =
      MultiResponse<List<User>>.fromJson(await response, (jsonList) {
        if (jsonList != null) {
          staffs = (jsonList as List).map((i) => User.fromJson(i)).toList();
          return staffs;
        } else {
          throw "no Data Available";
        }
      });
      var nextPageTotal = (page) * 20;
      if (nextPageTotal >= (mainResponse.count)) {
        isLastPage = true;
      }

      if (await staffs.isNotEmpty) {
        return Tuple2(await staffs, isLastPage);
      } else {
        throw "no Data Available";
      }
      // var jsonObject = json.decode(object!) as List;
      // childes = (jsonObject).map((i) => Child.fromJson(i)).toList();
    } catch (e) {
      rethrow;
    }
  }

}
