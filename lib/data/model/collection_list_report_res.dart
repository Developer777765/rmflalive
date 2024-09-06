

import 'dart:convert';

import '/domain/entity/collction_list_report_res_entity.dart';

CollectionListReportRes collectionListReportResFromJson(String str) =>
    CollectionListReportRes.fromJson(json.decode(str));

String collectionListReportResToJson(CollectionListReportRes data) =>
    json.encode(data.toJson());

// ignore: must_be_immutable
class CollectionListReportRes extends CollectionListReportResEntity {
  CollectionListReportRes({
    required status,
    required statusCode,
    required result,
  }) : super(status: status, statusCode: statusCode, result: result);

  factory CollectionListReportRes.fromJson(Map<String, dynamic> json) =>
      CollectionListReportRes(
        status: json["status"],
        statusCode: json["statusCode"],
        result:
            List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "statusCode": statusCode,
        "result": List<dynamic>.from(result!.map((x) => x.toJson())),
      };
}

// ignore: must_be_immutable
class Result extends ResultEntity {
  Result({
    required pkId,
    required groupId,
    required groupName,
    groupIdFk,
    required loanNo,
    required lnAmt,
    required collectedAmount,
    required remittedAmount,
    required status,
    required collectedDate,
    required memberName,
    loginId,
    staffName,
    staffNo,
    required colnTxnId,
    required remitPkId,
    required receiptNo,
  }) : super(
            pkId: pkId,
            groupId: groupId,
            groupName: groupName,
            groupIdFk: groupIdFk,
            loanNo: loanNo,
            lnAmt: lnAmt,
            collectedAmount: collectedAmount,
            remittedAmount: remittedAmount,
            status: status,
            collectedDate: collectedDate,
            memberName: memberName,
            loginId: loginId,
            staffName: staffName,
            staffNo: staffNo,
            colnTxnId: colnTxnId,
            remitPkId: remitPkId,
            receiptNo: receiptNo
            );

  factory Result.fromJson(Map<String, dynamic> json) => Result(
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
}
