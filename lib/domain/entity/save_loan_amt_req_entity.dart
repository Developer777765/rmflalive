import 'dart:convert';

SaveLnAmtReqEntity saveLnAmtReqEntityFromJson(String str) =>
    SaveLnAmtReqEntity.fromJson(json.decode(str));

String saveLnAmtReqEntityToJson(SaveLnAmtReqEntity data) =>
    json.encode(data.toJson());

class SaveLnAmtReqEntity {
  SaveLnAmtReqEntity({
    required this.loginId,
    required this.platfrom,
    // required this.productId,
    required this.tokenNo,
    required this.loanAmountlist,
  });

  List<LoanAmountlist> loanAmountlist;
  String loginId;
  String platfrom;
  // String productId;
  String tokenNo;

  factory SaveLnAmtReqEntity.fromJson(Map<String, dynamic> json) =>
      SaveLnAmtReqEntity(
        loanAmountlist: List<LoanAmountlist>.from(
            json["loanAmountlist"].map((x) => LoanAmountlist.fromJson(x))),
        loginId: json["loginID"],
        platfrom: json["platfrom"],
        // productId: json["productId"],
        tokenNo: json["tokenNo"],
      );

  Map<String, dynamic> toJson() => {
        "loanAmountlist":
            List<dynamic>.from(loanAmountlist.map((x) => x.toJson())),
        "loginID": loginId,
        "platfrom": platfrom,
        // "productId": productId,
        "tokenNo": tokenNo,
      };
}

class LoanAmountlist {
  LoanAmountlist({
    required this.prId,
    this.brId,
    this.groupId,
    this.receiptNo,
    this.collectedAmt,
    this.collectedDate,
    this.createdby,
    this.groupName,
    this.lnAmt,
    this.loanNo,
    this.loginId,
    this.memName,
    this.status,
  });
  String? prId;
  String? brId;
  String? groupId;
  String? receiptNo;
  int? collectedAmt;
  String? collectedDate;
  String? createdby;
  String? groupName;
  int? lnAmt;
  String? loanNo;
  String? loginId;
  String? memName;
  String? status;

  factory LoanAmountlist.fromJson(Map<String, dynamic> json) => LoanAmountlist(
        brId: json["BrID"],
        groupId: json["GroupId"],
        receiptNo: json["receiptNo"],
        prId: json["PrdId"],
        collectedAmt: json["collectedAmt"],
        collectedDate: json["collectedDate"],
        createdby: json["createdby"],
        groupName: json["groupName"],
        lnAmt: json["lnAmt"],
        loanNo: json["loanNo"],
        loginId: json["loginId"],
        memName: json["memName"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "BrID": brId,
        "GroupId": groupId,
        "receiptNo": receiptNo,
        "PrdId": prId,
        "collectedAmt": collectedAmt,
        "collectedDate": collectedDate,
        "createdby": createdby,
        "groupName": groupName,
        "lnAmt": lnAmt,
        "loanNo": loanNo,
        "loginId": loginId,
        "memName": memName,
        "status": status,
      };
}
