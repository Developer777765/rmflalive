import 'package:either_dart/either.dart';
import '/data/Failure.dart';
import '/domain/entity/check_collection_list_status_res_entity.dart';

abstract class CheckCollectionListRep {
  Future<Either<Failure, CheckCollectedListStatusResEntity>>
      CheckCollectionListRes(String body);
}
