// To parse this JSON data, do
//
//     final dailyStatusCheckReq = dailyStatusCheckReqFromJson(jsonString);

import 'dart:convert';

DailyStatusCheckReq dailyStatusCheckReqFromJson(String str) => DailyStatusCheckReq.fromJson(json.decode(str));

String dailyStatusCheckReqToJson(DailyStatusCheckReq data) => json.encode(data.toJson());

class DailyStatusCheckReq {
    DailyStatusCheckReq({
        required this.brId,
        required this.loginId,
        required this.platfrom,
        required this.productId,
        required this.status,
        required this.tokenNo,
    });

    String brId;
    String loginId;
    String platfrom;
    String productId;
    String status;
    String tokenNo;

    factory DailyStatusCheckReq.fromJson(Map<String, dynamic> json) => DailyStatusCheckReq(
        brId: json["brID"],
        loginId: json["loginID"],
        platfrom: json["platfrom"],
        productId: json["productId"],
        status: json["status"],
        tokenNo: json["tokenNo"],
    );

    Map<String, dynamic> toJson() => {
        "brID": brId,
        "loginID": loginId,
        "platfrom": platfrom,
        "productId": productId,
        "status": status,
        "tokenNo": tokenNo,
    };
}
