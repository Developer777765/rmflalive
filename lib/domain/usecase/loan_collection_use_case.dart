// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:either_dart/either.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/data/Failure.dart';

import '/domain/entity/loan_collection_res_entity.dart';
import '/domain/repository/loan_collection_repository.dart';

import '../../data/model/remitted_screen_model.dart';
import '../../data/repositoryImpl/loan_collection_repossitory_imply.dart';

final loanCollectionUseCaseProvider = StateProvider((ref) {
  return LoanCollectionUseCase(
      loanCollectionRepository: ref.watch(LoanCollectionRepositoryProvider));
});

class LoanCollectionUseCase {
  final LoanCollectionRepository loanCollectionRepository;

  LoanCollectionUseCase({
    required this.loanCollectionRepository,
  });

  Future<Either<Failure, LoanCollectionResponseEntity>> loanCollectionRes(
      String body) async {
    return await loanCollectionRepository.getLoanCollectionResponse(body);
  }

  Future<Either<Failure, List<ResultEntity>>> getUniqueGroupList() async {
    return await loanCollectionRepository.getLoanGroups();
  }

  Future<Either<Failure, int>> insertLoanListToDB(
      List<ResultEntity> list) async {
    return await loanCollectionRepository.insertLoanList(list);
  }

  Future<Either<Failure, List<ResultEntity>>> getListByGroupId(
      String id) async {
    return await loanCollectionRepository.getLoanListByGroupID(id);
  }

  Future<Either<Failure, List<ResultEntity>>> getAllDataFromDb() async {
    return await loanCollectionRepository.getAllDataFromDb();
  }

    
  Future<Either<Failure, List<Remittedldb>>> getUnsyncedData(
      int boolinInt) async {
    return await loanCollectionRepository.getUnsyncedData(0);
  }
}
