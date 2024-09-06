import 'dart:convert';

LoginEntity loginEntityFromJson(String str) =>
    LoginEntity.fromJson(json.decode(str));

String loginEntityToJson(LoginEntity data) => json.encode(data.toJson());

class LoginEntity {
  LoginEntity({
    this.branchId,
    this.isValidOn,
    this.loginId,
    this.loginType,
    this.mobileNo,
    this.password,
    this.platfrom,
    this.uniqueId,
    this.userRole,
  });
  String? branchId;
  bool? isValidOn;
  String? loginId;
  String? loginType;
  String? mobileNo;
  String? password;
  String? platfrom;
  String? uniqueId;
  String? userRole;

  factory LoginEntity.fromJson(Map<String, dynamic> json) => LoginEntity(
        branchId: json["branchId"],
        isValidOn: json["isValidOn"],
        loginId: json["loginID"],
        loginType: json["loginType"],
        mobileNo: json["mobileNo"],
        password: json["password"],
        platfrom: json["platfrom"],
        uniqueId: json["uniqueId"],
        userRole: json["userRole"],
      );

  Map<String, dynamic> toJson() => {
        "branchId": branchId,
        "isValidOn": isValidOn,
        "loginID": loginId,
        "loginType": loginType,
        "mobileNo": mobileNo,
        "password": password,
        "platfrom": platfrom,
        "uniqueId": uniqueId,
        "userRole": userRole,
      };
}
