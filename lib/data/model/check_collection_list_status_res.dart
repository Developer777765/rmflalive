// To parse this JSON data, do
//
//     final checkCollectedListStatusRes = checkCollectedListStatusResFromJson(jsonString);

import 'dart:convert';

import '../../domain/entity/check_collection_list_status_res_entity.dart';

CheckCollectedListStatusRes checkCollectedListStatusResFromJson(String str) =>
    CheckCollectedListStatusRes.fromJson(json.decode(str));

String checkCollectedListStatusResToJson(CheckCollectedListStatusRes data) =>
    json.encode(data.toJson());

// ignore: must_be_immutable
class CheckCollectedListStatusRes extends CheckCollectedListStatusResEntity {
  CheckCollectedListStatusRes({
    required status,
    required statusCode,
    required result,
  }) : super(status: status, statusCode: statusCode, result: result);

  factory CheckCollectedListStatusRes.fromJson(Map<String, dynamic> json) =>
      CheckCollectedListStatusRes(
        status: json["status"],
        statusCode: json["statusCode"],
        result: Result.fromJson(json["result"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "statusCode": statusCode,
        "result": result.toJson(),
      };
}

// ignore: must_be_immutable
class Result extends ResultEntity {
  Result({
    required lastRemitDate,
    required checkStatusLists,
  }) : super(lastRemitDate: lastRemitDate, checkStatusLists: checkStatusLists);

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        lastRemitDate: DateTime.parse(json["lastRemitDate"]),
        checkStatusLists: List<CheckStatusList>.from(
            json["checkStatusLists"].map((x) => CheckStatusList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "lastRemitDate": lastRemitDate.toIso8601String(),
        "checkStatusLists":
            List<dynamic>.from(checkStatusLists.map((x) => x.toJson())),
      };
}

// ignore: must_be_immutable
class CheckStatusList extends CheckStatusListEntity {
  CheckStatusList({
    required receiptNo,
    required status,
  }) : super(receiptNo: receiptNo, status: status);

  factory CheckStatusList.fromJson(Map<String, dynamic> json) =>
      CheckStatusList(
        receiptNo: json["receiptNo"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "receiptNo": receiptNo,
        "status": status,
      };
}
