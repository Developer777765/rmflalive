import 'package:either_dart/either.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/data/Failure.dart';
import '/data/repositoryImpl/collection_list_report_res_repository_impl.dart';
import '/domain/entity/collction_list_report_res_entity.dart';
import '/domain/repository/collection_list_report_res_repository.dart';

final collectionListUseCaseProvider = StateProvider((ref) {
  return CollectionListReportUseCase(
      ref.watch(collectionListRepositoryProvider));
});

class CollectionListReportUseCase {
  final CollectionListReportResRepository collectionListReportResRepository;

  CollectionListReportUseCase(this.collectionListReportResRepository);

  Future<Either<Failure, CollectionListReportResEntity>> getCollectionListData(
      String body) async {
    return await collectionListReportResRepository.getCollectionListRes(body);
  }
}


final collectionListUseCaseProvider1 = StateProvider((ref) {
  return CollectionListReportUseCase(
      ref.watch(collectionListRepositoryProvider1));
});

class CollectionListReportUseCase1 {
  final CollectionListReportResRepository collectionListReportResRepository;

  CollectionListReportUseCase1(this.collectionListReportResRepository);

  Future<Either<Failure, CollectionListReportResEntity>> getCollectionListData(
      String body) async {
    return await collectionListReportResRepository.getCollectionListRes(body);
  }
}