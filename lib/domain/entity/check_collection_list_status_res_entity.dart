// To parse this JSON data, do
//
//     final checkCollectedListStatusRes = checkCollectedListStatusResFromJson(jsonString);

import 'dart:convert';

import 'package:equatable/equatable.dart';

CheckCollectedListStatusResEntity checkCollectedListStatusResFromJson(
        String str) =>
    CheckCollectedListStatusResEntity.fromJson(json.decode(str));

String checkCollectedListStatusResToJson(
        CheckCollectedListStatusResEntity data) =>
    json.encode(data.toJson());

// ignore: must_be_immutable
class CheckCollectedListStatusResEntity extends Equatable {
  CheckCollectedListStatusResEntity({
    required this.status,
    required this.statusCode,
    required this.result,
  });

  String status;
  String statusCode;
  ResultEntity result;

  factory CheckCollectedListStatusResEntity.fromJson(
          Map<String, dynamic> json) =>
      CheckCollectedListStatusResEntity(
        status: json["status"],
        statusCode: json["statusCode"],
        result: ResultEntity.fromJson(json["result"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "statusCode": statusCode,
        "result": result.toJson(),
      };

  @override
  List<Object?> get props => [status, statusCode, result];
}

// ignore: must_be_immutable
class ResultEntity extends Equatable {
  ResultEntity({
    required this.lastRemitDate,
    required this.checkStatusLists,
  });

  DateTime lastRemitDate;
  List<CheckStatusListEntity> checkStatusLists;

  factory ResultEntity.fromJson(Map<String, dynamic> json) => ResultEntity(
        lastRemitDate: DateTime.parse(json["lastRemitDate"]),
        checkStatusLists: List<CheckStatusListEntity>.from(
            json["checkStatusLists"]
                .map((x) => CheckStatusListEntity.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "lastRemitDate": lastRemitDate.toIso8601String(),
        "checkStatusLists":
            List<dynamic>.from(checkStatusLists.map((x) => x.toJson())),
      };

  @override
  List<Object?> get props => [lastRemitDate, checkStatusLists];
}

// ignore: must_be_immutable
class CheckStatusListEntity extends Equatable {
  CheckStatusListEntity({
    required this.receiptNo,
    required this.status,
  });

  String receiptNo;
  String status;

  factory CheckStatusListEntity.fromJson(Map<String, dynamic> json) =>
      CheckStatusListEntity(
        receiptNo: json["receiptNo"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "receiptNo": receiptNo,
        "status": status,
      };

  @override
  List<Object?> get props => [receiptNo, status];
}




