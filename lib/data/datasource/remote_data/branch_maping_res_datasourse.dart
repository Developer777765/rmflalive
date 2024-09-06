import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/core/api_constant.dart';
import '/core/api_manager.dart';
import '/core/string_manger.dart';
import '/domain/entity/branch_maping_entity.dart';

import '../../model/branch_maping_res_model.dart';

abstract class BranchMapingDataSource {
  Future<BranchMapingResEntity> getData(String body);
}

final branchMapingDataSourseProvider = Provider<BranchMapingDataSource>((ref) {
  return BranchMapingDataSourceImpl();
});

class BranchMapingDataSourceImpl extends BranchMapingDataSource {



  @override
  Future<BranchMapingResEntity> getData(String body) async {
    var resData;
    await APIManager.postAPICall(Apiconstant.admin_branch_maping, body)
        .then((value) {
      final res = branchMapingResModelFromJson(value);
      if (res.status == AppString.SUCCESS) {
        resData = res;
        debugPrint("Status Success: $resData");
      } else {
        resData = res;
        debugPrint("Status Success: $resData");
      }
    });
    return resData;
  }



  
}
