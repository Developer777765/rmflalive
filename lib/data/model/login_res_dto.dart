import 'dart:convert';

import '/domain/entity/login_res_entity.dart';

LoginResModel loginResFromJson(String str) =>
    LoginResModel.fromJson(json.decode(str));

// ignore: must_be_immutable
class LoginResModel extends LoginResEntity {
  LoginResModel({
    String? status,
    String? statusCode,
    Result? result,
  }) : super(status: status, statusCode: statusCode, result: result);

  factory LoginResModel.fromJson(Map<String, dynamic> json) => LoginResModel(
        status: json["status"],
        statusCode: json["statusCode"],
        result: Result.fromJson(json["result"]),
      );
}

// ignore: must_be_immutable
class Result extends ResultEntity {
  Result(
      {String? tokenNo,
      String? statusCode,
      String? status,
      String? errorMessage,
      String? message,
      String? usrId,
      String? empId,
      String? usrName,
      String? branchName,
      String? brId,
      String? defaultRoleId,
      String? roleId,
      dynamic emailId,
      String? mappedBrId,
      bool? isTabMapping,
      List<Branchlist>? branchlist,
      List<Menu>? menus,
      bool? isFirstLogin,
      String? password,
      String? pkID})
      : super(
            tokenNo: tokenNo,
            statusCode: statusCode,
            status: status,
            errorMessage: errorMessage,
            message: message,
            usrId: usrId,
            usrName: usrName,
            branchName: branchName,
            brId: brId,
            defaultRoleId: defaultRoleId,
            roleId: roleId,
            emailId: emailId,
            mappedBrId: mappedBrId,
            isTabMapping: isTabMapping,
            branchlist: branchlist,
            menus: menus,
            isFirstLogin: isFirstLogin,
            password: password,
            pkID: pkID);

  factory Result.fromJson(Map<String, dynamic> json) => Result(
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
      branchlist: json["branchlist"] == null
          ? []
          : List<Branchlist>.from(
              json["branchlist"].map((x) => Branchlist.fromJson(x))),
      menus: json["menus"] == null
          ? []
          : List<Menu>.from(json["menus"].map((x) => Menu.fromJson(x))),
      isFirstLogin: json["isFirstLogin"],
      password: json["password"],
      pkID: json["pkID"]);
}

// ignore: must_be_immutable
class Branchlist extends BranchlistEntity {
  Branchlist({
    String? brId,
    String? brName,
  }) : super(brId: brId, brName: brName);

  factory Branchlist.fromJson(Map<String, dynamic> json) => Branchlist(
        brId: json["brId"],
        brName: json["brName"],
      );
}

// ignore: must_be_immutable
class Menu extends MenuEntity {
  Menu({
    String? menuCode,
    String? menuName,
  }) : super(menuCode: menuCode, menuName: menuName);

  factory Menu.fromJson(Map<String, dynamic> json) => Menu(
        menuCode: json["menuCode"],
        menuName: json["menuName"],
      );
}
