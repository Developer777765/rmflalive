import 'dart:convert';

import '../../domain/entity/loan_collection_res_entity.dart';

LoanCollectionResponse loanCollectionResponseFromJson(String str) =>
    LoanCollectionResponse.fromJson(json.decode(str));

String loanCollectionResponseToJson(LoanCollectionResponse data) =>
    json.encode(data.toJson());

// ignore: must_be_immutable
class LoanCollectionResponse extends LoanCollectionResponseEntity {
  LoanCollectionResponse({
    required status,
    required statusCode,
    required result,
  }) : super(status: status, statusCode: statusCode, result: result);

  factory LoanCollectionResponse.fromJson(Map<String, dynamic> json) =>
      LoanCollectionResponse(
        status: json["status"],
        statusCode: json["statusCode"],
        result:
            List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "statusCode": statusCode,
        "result": List<dynamic>.from(result.map((x) => x.toJson())),
      };
}

// ignore: must_be_immutable
class Result extends ResultEntity {
  Result({
    required groupCode,
    required groupName,
    required lonaNo,
    required memberName,
    required loanAmt,
    required loanOs,
    required loanOverdue,
    required emiAmt,
    required brId,
    required prdId,
    required openingDt,
    required businessDate,
  }) : super(
            groupCode: groupCode,
            groupName: groupName,
            lonaNo: lonaNo,
            memberName: memberName,
            loanAmt: loanAmt,
            loanOs: loanOs,
            loanOverdue: loanOverdue,
            emiAmt: emiAmt,
            openingDt: openingDt,
            businessDate: businessDate,
            brId: brId);

  factory Result.fromJson(Map<String, dynamic> json) => Result(
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
        "openingDt": openingDt,
        "businessDate": businessDate,
      };
}
