import 'package:either_dart/src/either.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/data/Failure.dart';
import '/domain/entity/collction_list_report_res_entity.dart';
import '/domain/repository/collection_list_report_res_repository.dart';

import '../datasource/remote_data/collection_list_report_res_data_sourse.dart';

final collectionListRepositoryProvider =
    Provider<CollectionListReportResRepository>((ref) {
  return CollectionListReportResRepositoryImpl(
      collectionReportListDataSource:
          ref.watch(collectionListDataSourceProvider));
});

class CollectionListReportResRepositoryImpl
    extends CollectionListReportResRepository {
  final CollectionReportListDataSource collectionReportListDataSource;

  CollectionListReportResRepositoryImpl(
      {required this.collectionReportListDataSource});

  @override
  Future<Either<Failure, CollectionListReportResEntity>> getCollectionListRes(
      String body) async {
    try {
      final result =
          await collectionReportListDataSource.getListReportData(body);
      return Right(result);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}

final collectionListRepositoryProvider1 =
    Provider<CollectionListReportResRepository>((ref) {
  return CollectionListReportResRepositoryImpl(
      collectionReportListDataSource:
          ref.watch(collectionListDataSourceProvider1));
});

class CollectionListReportResRepositoryImpl1
    extends CollectionListReportResRepository {
  final CollectionReportListDataSource collectionReportListDataSource;

  CollectionListReportResRepositoryImpl1(
      {required this.collectionReportListDataSource});

  @override
  Future<Either<Failure, CollectionListReportResEntity>> getCollectionListRes(
      String body) async {
    try {
      final result =
          await collectionReportListDataSource.getListReportData(body);
      return Right(result);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}
