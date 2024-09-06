import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/data/datasource/remote_data/check_list_status_datasource.dart';
import '/domain/entity/check_collection_list_status_res_entity.dart';
import '/data/Failure.dart';
import 'package:either_dart/src/either.dart';
import '/domain/repository/check_collection_list_res_repository.dart';


final checkCollectionListStatusRepProvider = Provider<CheckCollectionListRep>((ref) {
  return  CheckCollectionListStatusRepImpl(checkCollectionListDataSourse: ref.watch(checkCollectionListDataSourceProvider));
});

class CheckCollectionListStatusRepImpl extends CheckCollectionListRep {
  final CheckCollectionListDataSourse checkCollectionListDataSourse;

  CheckCollectionListStatusRepImpl(
      {required this.checkCollectionListDataSourse});
  @override
  Future<Either<Failure, CheckCollectedListStatusResEntity>>
      CheckCollectionListRes(String body) async {
    try {
      final result = await checkCollectionListDataSourse.getData(body);
      return Right(result);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}
