import 'dart:convert';

import 'package:equatable/equatable.dart';

LoginResEntity loginResEntityFromJson(String str) =>
    LoginResEntity.fromJson(json.decode(str));

String loginResToJson(LoginResEntity data) => json.encode(data.toJson());

// ignore: must_be_immutable
class LoginResEntity extends Equatable {
  LoginResEntity({
    this.status,
    this.statusCode,
    this.result,
  });

  String? status;
  String? statusCode;
  ResultEntity? result;

  factory LoginResEntity.fromJson(Map<String, dynamic> json) => LoginResEntity(
        status: json["status"],
        statusCode: json["statusCode"],
        result: ResultEntity.fromJson(json["result"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "statusCode": statusCode,
        "result": result!.toJson(),
      };

  @override
  List<Object?> get props => [status, statusCode, result];
}

// ignore: must_be_immutable
class ResultEntity extends Equatable {
  ResultEntity(
      {this.tokenNo,
      this.statusCode,
      this.status,
      this.errorMessage,
      this.message,
      this.usrId,
      this.empId,
      this.usrName,
      this.branchName,
      this.brId,
      this.defaultRoleId,
      this.roleId,
      this.emailId,
      this.mappedBrId,
      this.isTabMapping,
      this.branchlist,
      this.menus,
      this.isFirstLogin,
      this.password,
      this.pkID});

  String? tokenNo;
  String? statusCode;
  String? status;
  String? errorMessage;
  String? message;
  String? usrId;
  String? empId;
  String? usrName;
  String? branchName;
  String? brId;
  String? defaultRoleId;
  String? roleId;
  String? emailId;
  String? mappedBrId;
  bool? isTabMapping;
  List<BranchlistEntity>? branchlist;
  List<MenuEntity>? menus;
  bool? isFirstLogin;
  String? password;
  String? pkID;

  factory ResultEntity.fromJson(Map<String, dynamic> json) => ResultEntity(
      tokenNo: json["tokenNo"],
      statusCode: json["statusCode"],
      status: json["status"],
      errorMessage: json["errorMessage"],
      message: json["message"],
      usrId: json["usrId"],
      empId: json["empId"],
      usrName: json["usrName"],
      branchName: json["branchName"],
      brId: json["brId"],
      defaultRoleId: json["defaultRoleId"],
      roleId: json["roleId"],
      emailId: json["emailId"],
      mappedBrId: json["mappedBrID"],
      isTabMapping: json["isTabMapping"],
      branchlist: json["branchlist"],
      menus: json["menus"] == null
          ? []
          : List<MenuEntity>.from(
              json["menus"].map((x) => MenuEntity.fromJson(x))),
      isFirstLogin: json["isFirstLogin"],
      password: json["password"],
      pkID: json["pkID"]);

  Map<String, dynamic> toJson() => {
        "tokenNo": tokenNo,
        "statusCode": statusCode,
        "status": status,
        "errorMessage": errorMessage,
        "message": message,
        "usrId": usrId,
        "empId": empId,
        "usrName": usrName,
        "branchName": branchName,
        "brId": brId,
        "defaultRoleId": defaultRoleId,
        "roleId": roleId,
        "emailId": emailId,
        "mappedBrID": mappedBrId,
        "isTabMapping": isTabMapping,
        "branchlist": branchlist,
        "menus": List<dynamic>.from(menus!.map((x) => x.toJson())),
      };

  @override
  List<Object?> get props => [
        tokenNo,
        statusCode,
        status,
        errorMessage,
        message,
        usrId,
        emailId,
        usrName,
        branchName,
        brId,
        defaultRoleId,
        roleId,
        emailId,
        mappedBrId,
        mappedBrId,
        isTabMapping,
        branchlist,
        menus
      ];
}

// ignore: must_be_immutable
class BranchlistEntity extends Equatable {
  BranchlistEntity({
    this.brId,
    this.brName,
  });

  String? brId;
  String? brName;

  factory BranchlistEntity.fromJson(Map<String, dynamic> json) =>
      BranchlistEntity(
        brId: json["brId"],
        brName: json["brName"],
      );

  Map<String, dynamic> toJson() => {
        "brId": brId,
        "brName": brName,
      };

  @override
  List<Object?> get props => [brId, brName];
}

// ignore: must_be_immutable
class MenuEntity extends Equatable {
  MenuEntity({
    this.menuCode,
    this.menuName,
  });

  String? menuCode;
  String? menuName;

  factory MenuEntity.fromJson(Map<String, dynamic> json) => MenuEntity(
        menuCode: json["menuCode"],
        menuName: json["menuName"],
      );

  Map<String, dynamic> toJson() => {
        "menuCode": menuCode,
        "menuName": menuName,
      };

  @override
  List<Object?> get props => [menuCode, menuName];
}
