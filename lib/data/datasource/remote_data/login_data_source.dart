import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/core/api_constant.dart';
import '/core/api_manager.dart';
import '/core/string_manger.dart';
import '/data/model/login_res_dto.dart';
import '/data/model/user_mapping_req_res.dart';
import '/domain/entity/login_res_entity.dart';

// import '../../../core/api_constant.dart';
// import '../../../core/api_manager.dart';
// import '../../../domain/entity/login_res_entity.dart';
// import '../../model/user_mapping_req_res.dart';

abstract class LoginDataSource {
  Future<LoginResEntity> checkLogin(String body);
  Future<List<UsermappingResponse>?> getUserMapping(String body);
  Future<InsertUserResponse?> insertUser(String body);
  Future<ChangePassResult?> changePassword(String body);
}

final loginDataSourceProvider =
    Provider<LoginDataSource>((ref) => LoginDataSourceImpl());

class LoginDataSourceImpl extends LoginDataSource {
  @override
  Future<LoginResEntity> checkLogin(String body) async {
    var loginuser;
    final response = await APIManager.postAPICall(Apiconstant.LOGIN_URL, body);

    final res = loginResFromJson(response);

    if (res.status == AppString.SUCCESS) {
      loginuser = res;
    } else {
      loginuser = response;
    }
    return loginuser;
  }

  @override
  Future<List<UsermappingResponse>?> getUserMapping(String body) async {
    var returnData;
    await APIManager.postAPICall(Apiconstant.GETUSERMAPPING, body)
        .then((value) {
      final res = userMappingResFromJson(value);
      if (res.status == AppString.SUCCESS) {
        returnData = res.result;
        debugPrint(res.toString());
      }
    });
    return returnData;
  }

  @override
  Future<InsertUserResponse?> insertUser(String body) async {
    try {
      var returnData;
      await APIManager.postAPICall(Apiconstant.INSERTUSER, body).then((value) {
        final res = changePasswordResFromJson(value);
        if (res.status == AppString.SUCCESS) {
          returnData = res.result;
        }
      });
      return returnData;
    } catch (ex) {
      debugPrint("Login Data Sourse File insertUser :${ex.toString()}");
      return null;
    }
  }

  @override
  Future<ChangePassResult?> changePassword(String body) async {
    try {
      var returnData;
      await APIManager.postAPICall(Apiconstant.CHANGEPASSWORD, body)
          .then((value) {
        final res = changePasswordResponseFromJson(value);
        if (res.status == AppString.SUCCESS) {
          returnData = res.result;
        }
      });
      return returnData;
    } catch (ex) {
      debugPrint("Login Data Sourse File changePassword method:${ex.toString()}");
      return null;
    }
  }
}
