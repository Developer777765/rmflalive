// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:either_dart/src/either.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/data/Failure.dart';
import '/domain/entity/save_loan_amt_res_entity.dart';

import '../../domain/repository/save_ln_amt_rep.dart';
import '../datasource/remote_data/save_ln_amt_dartsource.dart';

final saveLnAmtRepProvider = Provider<SavelnAmtRep>(
  (ref) => SaveLnAmtRepImpl(
      saveLoanAmtDatasource: ref.watch(SaveLnAmtDatasourceProvider)),
);

class SaveLnAmtRepImpl extends SavelnAmtRep {
  final SaveLoanAmtDatasource saveLoanAmtDatasource;
  SaveLnAmtRepImpl({
    required this.saveLoanAmtDatasource,
  });
  @override
  Future<Either<Failure, SaveLnAmtResEntity>> getRepData(String body) async {
    try {
      final result = await saveLoanAmtDatasource.getData(body);
      return Right(result);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}
