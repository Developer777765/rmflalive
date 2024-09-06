// To parse this JSON data, do
//
//     final checkCollectedListStatusReq = checkCollectedListStatusReqFromJson(jsonString);

import 'dart:convert';

CheckCollectedListStatusReq checkCollectedListStatusReqFromJson(String str) => CheckCollectedListStatusReq.fromJson(json.decode(str));

String checkCollectedListStatusReqToJson(CheckCollectedListStatusReq data) => json.encode(data.toJson());

class CheckCollectedListStatusReq {
    CheckCollectedListStatusReq({
        required this.loginId,
        required this.brId,
        required this.receiptNo,
        required this.tokenNo,
        required this.platfrom,
    });

    String loginId;
    String brId;
    List<String> receiptNo;
    String tokenNo;
    String platfrom;

    factory CheckCollectedListStatusReq.fromJson(Map<String, dynamic> json) => CheckCollectedListStatusReq(
        loginId: json["loginID"],
        brId: json["brID"],
        receiptNo: List<String>.from(json["receiptNo"].map((x) => x)),
        tokenNo: json["tokenNo"],
        platfrom: json["platfrom"],
    );

    Map<String, dynamic> toJson() => {
        "loginID": loginId,
        "brID": brId,
        "receiptNo": List<dynamic>.from(receiptNo.map((x) => x)),
        "tokenNo": tokenNo,
        "platfrom": platfrom,
    };
}
