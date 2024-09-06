import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/core/api_constant.dart';
import '/core/api_manager.dart';
import '/core/string_manger.dart';

import '/domain/entity/loan_collection_res_entity.dart';

abstract class LoanCollectionDataSourse {
  Future<LoanCollectionResponseEntity> getData(String body);
}

final loanCollectionDataSourceProvider =
    Provider<LoanCollectionDataSourse>((ref) {
  return LoanCollectionDataSourseImpl();
});

class LoanCollectionDataSourseImpl extends LoanCollectionDataSourse {
  @override
  Future<LoanCollectionResponseEntity> getData(String body) async {
    var collectionAmtRes;
    await APIManager.postAPICall(Apiconstant.Loan_collection_Amt, body).then(
      (value) {
        final res = loanCollectionResponseEntityFromJson(value);
        if (res.status == AppString.SUCCESS) {
          collectionAmtRes = res;
        } else {
          collectionAmtRes = value;
        }
      },
    );
    return collectionAmtRes;
  }
}
