import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/domain/entity/save_loan_amt_req_entity.dart';
import '/feature/page/non_remitted_collection/non_remitted_collection.dart';

import '../../domain/usecase/save-ln_amt_usecaswe.dart';
import '../page/login/admin_login_screen.dart';
import 'login_provider.dart';

final saveLnAmtProvider = StateProvider(
  (ref) {
    return ref.watch(saveLnAmtUsecaseProvider).getData(SaveLnAmtReq().body(
        ref.watch(lnsavedataProvider),
        ref.read(userIdProvider),
        ref.read(tokenProvider)));
  },
);

class SaveLnAmtReq {
  String body(
    List<LoanAmountlist> list,
    String userName,
    String token,
  ) {
    var req = SaveLnAmtReqEntity(
        loanAmountlist: list,
        loginId: userName,
        platfrom: "Mobile",
        // productId: productId,
        tokenNo: token);

    var body = saveLnAmtReqEntityToJson(req);
    debugPrint("body :$body");

    return body;
  }
}
