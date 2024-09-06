import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/data/datasource/loacal_database/money_collection_datasource.dart';
import '/data/model/remitted_screen_model.dart';

import '/domain/entity/loan_collection_res_entity.dart';
import '/data/Failure.dart';
import 'package:either_dart/src/either.dart';
import '/domain/repository/loan_collection_repository.dart';

import '../datasource/remote_data/loan_collection_data_sourse.dart';

final LoanCollectionRepositoryProvider =
    Provider<LoanCollectionRepository>((ref) {
  return LoanCollectionRepositoryImpl(
      loanCollectionDataSourse: ref.watch(loanCollectionDataSourceProvider),
      moneyCollectionDataSource: ref.read(moneyCollectionDataSourceProvider));
});

class LoanCollectionRepositoryImpl extends LoanCollectionRepository {
  final LoanCollectionDataSourse loanCollectionDataSourse;
  final MoneyCollectionDataSource moneyCollectionDataSource;

  LoanCollectionRepositoryImpl(
      {required this.loanCollectionDataSourse,
      required this.moneyCollectionDataSource});

  @override
  Future<Either<Failure, LoanCollectionResponseEntity>>
      getLoanCollectionResponse(String body) async {
    try {
      final result = await loanCollectionDataSourse.getData(body);
      return Right(result);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ResultEntity>>> getLoanGroups() async {
    try {
      final res = await moneyCollectionDataSource.getUniqueGroupNameAndCode();
      return Right(res);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> insertLoanList(List<ResultEntity> list) async {
    try {
       await moneyCollectionDataSource.insertDataToDb(list);
      return Right(1);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ResultEntity>>> getLoanListByGroupID(
      String groupID) async {
    try {
      final result = await moneyCollectionDataSource.readDataFromDbByGroupCode(
          groupCode: groupID);
      result.sort((a, b) => a.lonaNo!.compareTo(b.lonaNo!));
      return Right(result);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ResultEntity>>> getAllDataFromDb() async {
    try {
      final result = await moneyCollectionDataSource.getAllDataFromDb();
      return Right(result);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Remittedldb>>> getUnsyncedData(
      int boolinInt) async {
    try {
      final result = await moneyCollectionDataSource.getUnsyncedData(0);
      return Right(result);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}
