

import 'dart:convert';

LoanCollectionReqEntity loanCollectionReqEntityFromJson(String str) => LoanCollectionReqEntity.fromJson(json.decode(str));

String loanCollectionReqEntityToJson(LoanCollectionReqEntity data) => json.encode(data.toJson());

class LoanCollectionReqEntity {
    LoanCollectionReqEntity({
        required this.brId,
        required this.tokenNo,
        required this.loginId,
        required this.platfrom,
    });

    String brId;
    String tokenNo;
    String loginId;
    String platfrom;

    factory LoanCollectionReqEntity.fromJson(Map<String, dynamic> json) => LoanCollectionReqEntity(
        brId: json["brID"],
        tokenNo: json["tokenNo"],
        loginId: json["loginID"],
        platfrom: json["platfrom"],
    );

    Map<String, dynamic> toJson() => {
        "brID": brId,
        "tokenNo": tokenNo,
        "loginID": loginId,
        "platfrom": platfrom,
    };
}
