import 'dart:convert';

import 'package:equatable/equatable.dart';

LoanCollectionResponseEntity loanCollectionResponseEntityFromJson(String str) =>
    LoanCollectionResponseEntity.fromJson(json.decode(str));

String loanCollectionResponseEntityToJson(LoanCollectionResponseEntity data) =>
    json.encode(data.toJson());

// ignore: must_be_immutable
class LoanCollectionResponseEntity extends Equatable {
  LoanCollectionResponseEntity({
    required this.status,
    required this.statusCode,
    required this.result,
  });

  String status;
  String statusCode;
  List<ResultEntity> result;

  factory LoanCollectionResponseEntity.fromJson(Map<String, dynamic> json) =>
      LoanCollectionResponseEntity(
        status: json["status"],
        statusCode: json["statusCode"],
        result: List<ResultEntity>.from(
            json["result"].map((x) => ResultEntity.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "statusCode": statusCode,
        "result": List<ResultEntity>.from(result.map((x) => x.toJson())),
      };

  @override
  List<Object?> get props => [status, statusCode, result];
}

// ignore: must_be_immutable
class ResultEntity extends Equatable {
  ResultEntity({
    this.groupCode,
    this.groupName,
    this.lonaNo,
    this.memberName,
    this.loanAmt,
    this.loanOs,
    this.loanOverdue,
    this.emiAmt,
    this.brId,
    this.prdId,
    this.openingDt,
    this.businessDate,
  });

  String? groupCode;
  String? groupName;
  String? lonaNo;
  String? memberName;
  num? loanOs;
  num? loanOverdue;
  num? loanAmt;
  num? emiAmt;
  String? brId;
  dynamic prdId;
  String? openingDt;
  String? businessDate;

  factory ResultEntity.fromJson(Map<String, dynamic> json) => ResultEntity(
        groupCode: json["groupCode"],
        groupName: json["groupName"],
        lonaNo: json["lonaNo"],
        memberName: json["memberName"],
        loanAmt: json["loanAmt"],
        loanOs: json["loanOS"],
        loanOverdue: json["loanOverdue"],
        emiAmt: json["emiAmt"]?.toDouble(),
        brId: json["brID"],
        prdId: json["prdId"],
        openingDt: json["openingDt"],
        businessDate: json["businessDate"],
      );

  Map<String, dynamic> toJson() => {
        "groupCode": groupCode,
        "groupName": groupName,
        "lonaNo": lonaNo,
        "memberName": memberName,
        "loanAmt": loanAmt,
        "loanOS": loanOs,
        "loanOverdue": loanOverdue,
        "emiAmt": emiAmt,
        "brID": brId,
        "prdId": prdId,
        "openingDt": openingDt.toString(),
        "businessDate": businessDate.toString(),
      };

  @override
  List<Object?> get props => [
        groupCode,
        groupName,
        lonaNo,
        memberName,
        loanAmt,
        loanOs,
        loanOverdue,
        emiAmt,
        brId,
        prdId,
        openingDt,
        businessDate
      ];
}
