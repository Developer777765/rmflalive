import 'package:either_dart/either.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/data/Failure.dart';
import '/domain/entity/check_collection_list_status_res_entity.dart';
import '/domain/repository/check_collection_list_res_repository.dart';

import '../../data/repositoryImpl/check_list_status_rep_impl.dart';

final checkCollectionListStatusUseCaseProvider = StateProvider((ref) {
  return CheckCollectionListStatusUseCase(
      ref.watch(checkCollectionListStatusRepProvider));
});

class CheckCollectionListStatusUseCase {
  final CheckCollectionListRep checkCollectionListRep;

  CheckCollectionListStatusUseCase(this.checkCollectionListRep);

  Future<Either<Failure, CheckCollectedListStatusResEntity>> getListStatusRes(
      body) async {
    return await checkCollectionListRep.CheckCollectionListRes(body);
  }
}
