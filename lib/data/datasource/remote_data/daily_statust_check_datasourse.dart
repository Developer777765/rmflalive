import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api_constant.dart';
import '../../../core/api_manager.dart';
import '../../../core/string_manger.dart';
import '../../../domain/entity/daily_statuscheck_entity.dart';

abstract class DailyStatusCheckDatasourse {
  Future<DailyStatusCheckResEntity> getDailyStatus(String body);
}

class DailyStatusCheckImpl extends DailyStatusCheckDatasourse {
  @override
  Future<DailyStatusCheckResEntity> getDailyStatus(body) async {
    var _resultRes;
    await APIManager.postAPICall(Apiconstant.CHECKTODAYCOLLECTIONSTATUS, body)
        .then((value) {
      final _res = dailyStatusCheckResFromJson(value);
      if (_res.status == AppString.SUCCESS) {
        print("Response" "${_res}");
        _resultRes = _res;
      }
    });
    return _resultRes;
  }
}

final dailyStatusCheck = Provider<DailyStatusCheckImpl>((ref) {
  return DailyStatusCheckImpl();
});
