import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/feature/provider/login_provider.dart';
import '../../data/model/daily_statuscheck_req_res.dart';
import '../../domain/usecase/dailystatus_check_usecase.dart';
import '../page/login/admin_login_screen.dart';

final dailyStatusCheckProvider = StateProvider((ref) {
  return ref.read(DailystatustUseCaseProvider).getDailtStatusRep(
      DailyStatusCheckBody.dSCBody(ref.read(userIdProvider),
          ref.read(tokenProvider), ref.read(brIdProvider)));
});

final loginIDprovider = StateProvider<String>((ref) {
  return "";
});

class DailyStatusCheckBody {
  final DailyStatusUseCase dailyStatusUseCase;
  DailyStatusCheckBody({required this.dailyStatusUseCase});
  static String dSCBody(String loginID, String token, String brid) {
    var res = DailyStatusCheckReq(
        brId: brid,
        loginId: loginID,
        platfrom: "Mobile",
        productId: "40", 
        status: "Approved",
        tokenNo: token);
    String body = dailyStatusCheckReqToJson(res);
    debugPrint(" body request: $body");
    return body;
  }
}
