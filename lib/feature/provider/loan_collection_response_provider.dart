import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/data/model/remitted_screen_model.dart';
import '/domain/entity/loan_collection_req_entity.dart';
import '/domain/entity/loan_collection_res_entity.dart';
import '/domain/usecase/loan_collection_use_case.dart';
import '/feature/provider/login_provider.dart';
import '../page/login/admin_login_screen.dart';

final loanCollectionListProvider = StateProvider((ref) {
  return ref
      .read(loanCollectionUseCaseProvider)
      .loanCollectionRes(ref.watch(loanCollectionReqProvider));
});

final loanCollectionReqProvider = StateProvider<String>((ref) =>
    LaonCollectionListReq().getBody(
        token: ref.watch(tokenProvider),
        userid: ref.watch(userIdProvider),
        brId: ref.watch(brIdProvider)));

final loanCollectionProvider = StateNotifierProvider(
    (ref) => LoanCollectionNotifier(ref.read(loanCollectionUseCaseProvider)));

class LoanCollectionNotifier extends StateNotifier {
  final LoanCollectionUseCase loanCollectionUseCase;

  LoanCollectionNotifier(this.loanCollectionUseCase) : super(null);

  Future<List<ResultEntity>> getGroupList() async {
    List<ResultEntity> entityList = [];
    var res = await loanCollectionUseCase.getUniqueGroupList();

    res.map((right) => entityList = right);

    return entityList;
  }

  Future<void> insertLoanDB(List<ResultEntity> data) async {
    
    await loanCollectionUseCase.insertLoanListToDB(data);
  }


  Future<List<ResultEntity>> getAlldataFromDb() async {
    List<ResultEntity> list = [];
    final res = await loanCollectionUseCase.getAllDataFromDb();
    await res.fold((left) => null, (right) {
      list = right;
    });
    return list;
  }

  Future<List<ResultEntity>> readLoanListByGroupID(String id) async {
    List<ResultEntity> list = [];
    final res = await loanCollectionUseCase.getListByGroupId(id);
    await res.fold((left) => null, (right) {
      list = right;
    });

    return list;
  }

  Future<List<Remittedldb>> getUnSyncedData() async {
    List<Remittedldb> list = [];
    final res = await loanCollectionUseCase.getUnsyncedData(0);
    await res.fold((left) => null, (right) {
      list = right;
    });
    return list;
  }
}

class LaonCollectionListReq {

  String getBody(
      {required String userid, required String brId, required String token}) {
    var req = LoanCollectionReqEntity(
        brId: brId, tokenNo: token, loginId: userid, platfrom: "Mobile");
    var body = loanCollectionReqEntityToJson(req);
    debugPrint("loan collection list provider : $body");
    return body;
  }
}
