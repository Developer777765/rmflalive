import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/core/string_manger.dart';
import '/domain/entity/branchMapingReq.dart';
import '/domain/usecase/admin_login_usecase.dart';
import '/feature/page/splash/splash_screen.dart';
import '/feature/provider/mobile_num_access_provider.dart';

import '../page/login/admin_login_screen.dart';
import '../page/login/admini_branch_screen.dart';

final branchMapingIscheckedProvider = StateProvider<bool>((ref) {
  return false;
});

final branchMapingProvider = StateProvider((ref) async {
  return await ref.watch(branchMapingUsecaseProvider).getData(
      body: BranchMapingreq().getBody(
          loginID: ref.watch(adminUserNameProvider),
          mobileNum: ref.read(mobileNumberProvider).mobileNumber,
          branchId: ref.watch(branchMapingTextProvider),
          uniqueId: ref.read(androidUniqueIdProvider),
          token: ref.watch(tokenProvider),
          isChecked: ref.watch(branchMapingIscheckedProvider)));
});


class BranchMapingreq {
  String getBody({
    required String mobileNum,
    required String loginID,
    required String uniqueId,
    required String branchId,
    required String token,
    required bool isChecked,
  }) {
    var req = BranchMapingReqEntity(
        tokenNo: token,
        loginId: loginID,
        platfrom: AppString.Mobile,
        branchMappingreq: BranchMappingreq(
            branchId: branchId,
            createdby: loginID,
            ischeck: isChecked,
            mobileNo: mobileNum,
            uniqueId: uniqueId));

    ///ncs
    var body = branchMapingReqEntityToJson(req);
    debugPrint( 'BranchMapingreq :$body');
    return body;
  }
}
