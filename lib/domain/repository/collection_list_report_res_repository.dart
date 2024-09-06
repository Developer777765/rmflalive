import 'package:either_dart/either.dart';
import '/data/Failure.dart';
import '/domain/entity/collction_list_report_res_entity.dart';

abstract class CollectionListReportResRepository {
  Future<Either<Failure, CollectionListReportResEntity>> getCollectionListRes(
      String body);
}
