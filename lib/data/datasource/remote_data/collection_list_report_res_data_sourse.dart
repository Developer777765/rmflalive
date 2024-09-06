import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/core/api_constant.dart';
import '/core/api_manager.dart';
import '/core/string_manger.dart';
import '/domain/entity/collction_list_report_res_entity.dart';

abstract class CollectionReportListDataSource {
  Future<CollectionListReportResEntity> getListReportData(String body);
}

final collectionListDataSourceProvider =
    Provider<CollectionReportListDataSource>((ref) {
  return CollectionReportListDatasourseImpl();
});

class CollectionReportListDatasourseImpl
    extends CollectionReportListDataSource {
  @override
  Future<CollectionListReportResEntity> getListReportData(String body) async {
    var resultReportData;
    await APIManager.postAPICall(Apiconstant.collection_list_report, body)
        .then((value) {
      final res = collectionListReportResEntityFromJson(value);
      if (res.status == AppString.SUCCESS) {
        resultReportData = res;
      } else {
        resultReportData = value;
      }
    });
    return resultReportData;
  }
}

final collectionListDataSourceProvider1 =
    Provider<CollectionReportListDataSource>((ref) {
  return CollectionReportListDatasourseImpl();
});

class CollectionReportListDatasourseImpl1
    extends CollectionReportListDataSource {
  @override
  Future<CollectionListReportResEntity> getListReportData(String body) async {
    var resultReportData;
    await APIManager.postAPICall(Apiconstant.collection_list_report, body)
        .then((value) {
      final res = collectionListReportResEntityFromJson(value);
      if (res.status == AppString.SUCCESS) {
        resultReportData = res;
      } else {
        resultReportData = value;
      }
    });
    return resultReportData;
  }
}
