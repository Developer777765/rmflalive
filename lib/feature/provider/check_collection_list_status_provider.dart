import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/domain/entity/check_collection_list_status_req.dart';
import '/feature/provider/login_provider.dart';

import '../../domain/usecase/check_collection_list_status_useCase.dart';
import '../page/login/admin_login_screen.dart';

final receiptNoListProvider = StateProvider<List<String>>((ref) {
  return [];
});

final collectionListStatusResProvider = StateProvider((ref) {
  return ref.read(checkCollectionListStatusUseCaseProvider).getListStatusRes(
      CheckStatusReq().getBody(
          brId: ref.read(brIdProvider),
          loginId: ref.read(userIdProvider),
          recieptNoList: ref.watch(receiptNoListProvider),
          token: ref.read(tokenProvider)));
});

class CheckStatusReq {

  String getBody(
      {required List<String> recieptNoList,
      required String token,
      required String loginId,
      required String brId}) {
    var req = CheckCollectedListStatusReq(
        loginId: loginId,
        brId: brId,
        receiptNo: recieptNoList,
        tokenNo: token,
        platfrom: "Mobile");
    var body = checkCollectedListStatusReqToJson(req);
    debugPrint(" CheckStatusReq body:" "$body");
    return body;
  }
}
