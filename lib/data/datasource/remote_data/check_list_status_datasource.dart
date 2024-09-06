import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/core/api_constant.dart';
import '/core/api_manager.dart';
import '/core/string_manger.dart';
import '/domain/entity/check_collection_list_status_res_entity.dart';

abstract class CheckCollectionListDataSourse {
  Future<CheckCollectedListStatusResEntity> getData(String body);
}

final checkCollectionListDataSourceProvider =
    Provider<CheckCollectionListDataSourse>((ref) {
  return CheckCollectionListDataSourseImpl();
});

class CheckCollectionListDataSourseImpl extends CheckCollectionListDataSourse {
  @override
  Future<CheckCollectedListStatusResEntity> getData(String body) async {
    debugPrint("body :$body");
    var result;
    await APIManager.postAPICall(Apiconstant.check_collected_amt_list, body)
        .then((value) {
      final res = checkCollectedListStatusResFromJson(value);
      if (res.status == AppString.SUCCESS) {
        result = res;
        debugPrint("Success Res : $result}");
      } else {
        result = value;
        debugPrint("Failure Res : $result}");
      }
    });
    return result;
  }
}
