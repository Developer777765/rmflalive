import 'package:either_dart/either.dart';
import '/data/Failure.dart';
import '/domain/entity/loan_collection_res_entity.dart';

import '../../data/model/remitted_screen_model.dart';

abstract class LoanCollectionRepository {
  Future<Either<Failure, LoanCollectionResponseEntity>>
      getLoanCollectionResponse(String body);

  //LocalDB
  Future<Either<Failure, List<ResultEntity>>> getLoanGroups();
  Future<Either<Failure, int>> insertLoanList(List<ResultEntity> list);
  Future<Either<Failure, List<ResultEntity>>> getLoanListByGroupID(
      String groupID);
   Future<Either<Failure, List<ResultEntity>>> getAllDataFromDb();
    Future<Either<Failure, List<Remittedldb>>> getUnsyncedData(int boolinInt);
    

}
