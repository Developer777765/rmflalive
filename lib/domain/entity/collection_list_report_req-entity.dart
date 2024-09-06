
import 'dart:convert';

CollectionListReportReqEntity collectionListReportReqEntityFromJson(
        String str) =>
    CollectionListReportReqEntity.fromJson(json.decode(str));

String collectionListReportReqEntityToJson(
        CollectionListReportReqEntity data) =>
    json.encode(data.toJson());

class CollectionListReportReqEntity {
  CollectionListReportReqEntity({
    required this.brId,
    required this.fromDate,
    required this.loginId,
    required this.platfrom,
    required this.toDate,
    required this.tokenNo,
  });

  String brId;
  String fromDate;
  String loginId;
  String platfrom;
  String toDate;
  String tokenNo;

  factory CollectionListReportReqEntity.fromJson(Map<String, dynamic> json) =>
      CollectionListReportReqEntity(
        brId: json["BrID"],
        fromDate: json["fromDate"],
        loginId: json["loginID"],
        platfrom: json["platfrom"],
        toDate: json["toDate"],
        tokenNo: json["tokenNo"],
      );

  Map<String, dynamic> toJson() => {
        "BrID": brId,
        "fromDate": fromDate,
        "loginID": loginId,
        "platfrom": platfrom,
        "toDate": toDate,
        "tokenNo": tokenNo,
      };
}
