import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/domain/entity/collection_list_report_req-entity.dart';
import '/domain/usecase/collection_list_report_use_case.dart';
import '../page/login/admin_login_screen.dart';
import 'login_provider.dart';

final stratDateTxtFieldProvider = StateProvider<String>((ref) {
  return "";
});
final endDateTxtFieldProvider = StateProvider<String>((ref) {
  return "";
});

final dateStartApiProvider = StateProvider<String>((ref) {
  return "";
});

final dateEndtApiProvider = StateProvider<String>((ref) {
  return "";
});
final dateStartApiProvider1 = StateProvider<String>((ref) {
  return "";
});

final dateEndtApiProvider1 = StateProvider<String>((ref) {
  return "";
});

final collectionListProvider = FutureProvider.autoDispose((ref) => ref
    .watch(collectionListUseCaseProvider)
    .getCollectionListData(CollectionlistReq().getBody(
        brID: ref.read(brIdProvider),
        token: ref.read(tokenProvider),
        userName: ref.read(userIdProvider),
        startDate: ref.read(dateStartApiProvider),
        endDate: ref.read(dateEndtApiProvider))));

final collectionListProvider1 = FutureProvider.autoDispose((ref) => ref
    .watch(collectionListUseCaseProvider1)
    .getCollectionListData(CollectionlistReq().getBody(
        brID: ref.read(brIdProvider),
        token: ref.read(tokenProvider),
        userName: ref.read(userIdProvider),
        startDate: ref.read(dateStartApiProvider1),
        endDate: ref.read(dateEndtApiProvider1))));

class CollectionlistReq {
  String getBody({
    required String startDate,
    required String token,
    required String endDate,
    required String userName,
    required String brID,
  }) {
    var req = CollectionListReportReqEntity(
        brId: brID,
        fromDate: startDate,
        loginId: userName,
        platfrom: "Mobile",
        toDate: endDate,
        tokenNo: token);
    var body = collectionListReportReqEntityToJson(req);
    debugPrint("CollectionlistReq : $body");
    return body;
  }
}

