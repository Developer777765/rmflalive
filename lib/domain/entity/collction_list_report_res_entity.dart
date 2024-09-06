import 'dart:convert';

import 'package:equatable/equatable.dart';

CollectionListReportResEntity collectionListReportResEntityFromJson(
        String str) =>
    CollectionListReportResEntity.fromJson(json.decode(str));

String collectionListReportResEntityToJson(
        CollectionListReportResEntity data) =>
    json.encode(data.toJson());

// ignore: must_be_immutable
class CollectionListReportResEntity extends Equatable {
  CollectionListReportResEntity({
    this.status,
    this.statusCode,
    this.result,
  });

  String? status;
  String? statusCode;
  List<ResultEntity>? result;

  factory CollectionListReportResEntity.fromJson(Map<String, dynamic> json) =>
      CollectionListReportResEntity(
        status: json["status"],
        statusCode: json["statusCode"],
        result: List<ResultEntity>.from(
            json["result"].map((x) => ResultEntity.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "statusCode": statusCode,
        "result": List<dynamic>.from(result!.map((x) => x.toJson())),
      };

  @override
  List<Object?> get props => [status, statusCode, result];
}

// ignore: must_be_immutable
class ResultEntity extends Equatable {
  ResultEntity({
    this.pkId,
    this.groupId,
    this.groupName,
    this.groupIdFk,
    this.loanNo,
    this.lnAmt,
    this.collectedAmount,
    this.remittedAmount,
    this.status,
    this.collectedDate,
    this.memberName,
    this.loginId,
    this.staffName,
    this.staffNo,
    this.colnTxnId,
    this.remitPkId,
    this.receiptNo,
  });

  num? pkId;
  String? groupId;
  String? groupName;
  dynamic groupIdFk;
  String? loanNo;
  num? lnAmt;
  num? collectedAmount;
  num? remittedAmount;
  String? status;
  DateTime? collectedDate;
  String? memberName;
  dynamic loginId;
  dynamic staffName;
  dynamic staffNo;
  String? colnTxnId;
  num? remitPkId;
  String? receiptNo;

  factory ResultEntity.fromJson(Map<String, dynamic> json) => ResultEntity(
        pkId: json["pkId"],
        groupId: json["groupId"],
        groupName: json["groupName"],
        groupIdFk: json["groupIdFk"],
        loanNo: json["loanNo"],
        lnAmt: json["lnAmt"],
        collectedAmount: json["collectedAmount"],
        remittedAmount: json["remittedAmount"],
        status: json["status"],
        collectedDate: DateTime.parse(json["collectedDate"]),
        memberName: json["memberName"],
        loginId: json["loginId"],
        staffName: json["staffName"],
        staffNo: json["staffNo"],
        colnTxnId: json["colnTxnId"],
        remitPkId: json["remitPkId"],
        receiptNo: json["receiptNo"],
      );

  Map<String, dynamic> toJson() => {
        "pkId": pkId,
        "groupId": groupId,
        "groupName": groupName,
        "groupIdFk": groupIdFk,
        "loanNo": loanNo,
        "lnAmt": lnAmt,
        "collectedAmount": collectedAmount,
        "remittedAmount": remittedAmount,
        "status": status,
        "collectedDate": collectedDate!.toIso8601String(),
        "memberName": memberName,
        "loginId": loginId,
        "staffName": staffName,
        "staffNo": staffNo,
        "colnTxnId": colnTxnId,
        "remitPkId": remitPkId,
        "receiptNo": receiptNo,
      };

  @override
  List<Object?> get props => [
        pkId,
        groupId,
        groupName,
        groupIdFk,
        loanNo,
        lnAmt,
        collectedAmount,
        remittedAmount,
        status,
        collectedDate,
        memberName,
        loginId,
        staffName,
        staffNo,
        colnTxnId,
        remitPkId,
        receiptNo
      ];
}
