import 'package:either_dart/either.dart';
import '/data/Failure.dart';
import '/domain/entity/save_loan_amt_res_entity.dart';

abstract class SavelnAmtRep {
  Future<Either<Failure, SaveLnAmtResEntity>> getRepData(String body);
}
