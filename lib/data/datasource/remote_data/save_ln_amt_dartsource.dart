import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/core/api_constant.dart';
import '/core/api_manager.dart';
import '/core/string_manger.dart';
import '/domain/entity/save_loan_amt_res_entity.dart';

abstract class SaveLoanAmtDatasource {
  Future<SaveLnAmtResEntity>  getData(String body);
}

final SaveLnAmtDatasourceProvider = Provider<SaveLoanAmtDatasource>(
  (ref) => SaveLoanAmtDatasourceImpl(),
);

class SaveLoanAmtDatasourceImpl extends SaveLoanAmtDatasource {
  @override
  Future<SaveLnAmtResEntity> getData(String body) async {
    var result;
    await APIManager.postAPICall(Apiconstant.save_collected_ln_amt, body).then(
      (value) {
        final res = saveLnAmtResEntityFromJson(value);
        if (res.status == AppString.SUCCESS) {
          result = res;
        } else {
          result = value;
        }
      },
    );
    return result;
  }
}
