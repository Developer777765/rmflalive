// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:either_dart/either.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/data/Failure.dart';

import '../../data/repositoryImpl/save_ln_data_rep_impl.dart';
import '../entity/save_loan_amt_res_entity.dart';
import '../repository/save_ln_amt_rep.dart';

final saveLnAmtUsecaseProvider = Provider<SaveLnAmtUsecase>(
  (ref) => SaveLnAmtUsecase(saveLnAmtRep: ref.watch(saveLnAmtRepProvider)),
);

class SaveLnAmtUsecase {
  final SavelnAmtRep saveLnAmtRep;
  SaveLnAmtUsecase({
    required this.saveLnAmtRep,
  });

  Future<Either<Failure, SaveLnAmtResEntity>> getData(String body) {
    return saveLnAmtRep.getRepData(body);
  }
}
