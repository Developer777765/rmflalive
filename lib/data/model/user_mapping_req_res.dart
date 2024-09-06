import 'dart:convert';
// Response

UserMappingRes userMappingResFromJson(String str) =>
    UserMappingRes.fromJson(json.decode(str));

String userMappingResToJson(UserMappingRes data) => json.encode(data.toJson());

class UserMappingRes {
  String? status;
  String? statusCode;
  List<UsermappingResponse>? result;

  UserMappingRes({
    this.status,
    this.statusCode,
    this.result,
  });

  factory UserMappingRes.fromJson(Map<String, dynamic> json) => UserMappingRes(
        status: json["status"],
        statusCode: json["statusCode"],
        result: json["result"] == null
            ? []
            : List<UsermappingResponse>.from(
                json["result"]!.map((x) => UsermappingResponse.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "statusCode": statusCode,
        "result": result == null
            ? []
            : List<dynamic>.from(result!.map((x) => x.toJson())),
      };
}

class UsermappingResponse {
  String? usrid;
  String? userName;
  dynamic password;
  String? brId;
  String? usrRoleId;
  bool? isFirstLogin;
  bool? isActive;
  int? id;
  int? pkId;
  String? EmpId;
  String? DefaultRoleId;
  UsermappingResponse(
      {this.usrid,
      this.userName,
      this.password,
      this.brId,
      this.usrRoleId,
      this.isFirstLogin,
      this.isActive,
      this.id,
      this.pkId,
      this.EmpId,
      this.DefaultRoleId});

  factory UsermappingResponse.fromJson(Map<String, dynamic> json) =>
      UsermappingResponse(
        usrid: json["usrid"],
        userName: json["userName"],
        password: json["password"],
        brId: json["brId"],
        usrRoleId: json["usrRoleId"],
        isFirstLogin: json["isFirstLogin"],
        isActive: json["isActive"],
        id: json["id"],
        pkId: json["pk_ID"],
        EmpId: json["empId"],
        DefaultRoleId: json["defaultRoleId"],
      );

  Map<String, dynamic> toJson() => {
        "usrid": usrid,
        "userName": userName,
        "password": password,
        "brId": brId,
        "usrRoleId": usrRoleId,
        "isFirstLogin": isFirstLogin,
        "isActive": isActive,
        "id": id,
        "pk_ID": pkId,
      };
}

//Request

List<UserInsertReq> userInsertReqFromJson(String str) =>
    List<UserInsertReq>.from(
        json.decode(str).map((x) => UserInsertReq.fromJson(x)));

String userInsertReqToJson(List<UserInsertReq> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserInsertReq {
  String? usrid;
  String? userName;
  String? password;
  String? brId;
  String? usrRoleId;
  bool? isFirstLogin;
  bool? isActive;
  int? id;
  int? pkId;
  DateTime? createdDate;
  DateTime? modifiedDate;
  String? empId;
  String? defaultRoleId;

  UserInsertReq({
    this.usrid,
    this.userName,
    this.password,
    this.brId,
    this.usrRoleId,
    this.isFirstLogin,
    this.isActive,
    this.id,
    this.pkId,
    this.createdDate,
    this.modifiedDate,
    this.empId,
    this.defaultRoleId,
  });

  factory UserInsertReq.fromJson(Map<String, dynamic> json) => UserInsertReq(
        usrid: json["usrid"],
        userName: json["userName"],
        password: json["password"],
        brId: json["brId"],
        usrRoleId: json["usrRoleId"],
        isFirstLogin: json["isFirstLogin"],
        isActive: json["isActive"],
        id: json["id"],
        pkId: json["pk_ID"],
        createdDate: json["createdDate"] == null
            ? null
            : DateTime.parse(json["createdDate"]),
        modifiedDate: json["modifiedDate"] == null
            ? null
            : DateTime.parse(json["modifiedDate"]),
        empId: json["empId"],
        defaultRoleId: json["defaultRoleId"],
      );

  Map<String, dynamic> toJson() => {
        "usrid": usrid,
        "userName": userName,
        "password": password,
        "brId": brId,
        "usrRoleId": usrRoleId,
        "isFirstLogin": isFirstLogin,
        "isActive": isActive,
        "id": id,
        "pk_ID": pkId,
        "createdDate": createdDate?.toIso8601String(),
        "modifiedDate": modifiedDate?.toIso8601String(),
        "empId": empId,
        "defaultRoleId": defaultRoleId,
      };
}
//Change password request

ChangePasswordReq changePasswordReqFromJson(String str) =>
    ChangePasswordReq.fromJson(json.decode(str));

String changePasswordReqToJson(ChangePasswordReq data) =>
    json.encode(data.toJson());

class ChangePasswordReq {
  String? oldPassword;
  String? password;
  String? pkId;

  ChangePasswordReq({
    this.oldPassword,
    this.password,
    this.pkId,
  });

  factory ChangePasswordReq.fromJson(Map<String, dynamic> json) =>
      ChangePasswordReq(
        oldPassword: json["oldPassword"],
        password: json["password"],
        pkId: json["pkId"],
      );

  Map<String, dynamic> toJson() => {
        "oldPassword": oldPassword,
        "password": password,
        "pkId": pkId,
      };
}
// Change Password Response

ChangePasswordResponse changePasswordResponseFromJson(String str) =>
    ChangePasswordResponse.fromJson(json.decode(str));

String changePasswordResponseToJson(ChangePasswordResponse data) =>
    json.encode(data.toJson());

class ChangePasswordResponse {
  String? status;
  String? statusCode;
  ChangePassResult? result;

  ChangePasswordResponse({
    this.status,
    this.statusCode,
    this.result,
  });

  factory ChangePasswordResponse.fromJson(Map<String, dynamic> json) =>
      ChangePasswordResponse(
        status: json["status"],
        statusCode: json["statusCode"],
        result: json["result"] == null
            ? null
            : ChangePassResult.fromJson(json["result"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "statusCode": statusCode,
        "result": result?.toJson(),
      };
}

class ChangePassResult {
  String? response;

  ChangePassResult({
    this.response,
  });

  factory ChangePassResult.fromJson(Map<String, dynamic> json) =>
      ChangePassResult(
        response: json["response"],
      );

  Map<String, dynamic> toJson() => {
        "response": response,
      };
}

// Common Response

InsertUserResponse changePasswordResFromJson(String str) =>
    InsertUserResponse.fromJson(json.decode(str));

String changePasswordResToJson(InsertUserResponse data) =>
    json.encode(data.toJson());

class InsertUserResponse {
  String? status;
  String? statusCode;
  bool? result;

  InsertUserResponse({
    this.status,
    this.statusCode,
    this.result,
  });

  factory InsertUserResponse.fromJson(
          Map<String, dynamic> json) =>
      InsertUserResponse(
        status: json["status"],
        statusCode: json["statusCode"],
        result: json["result"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "statusCode": statusCode,
        "result": result,
      };
}
