// To parse this JSON data, do
//
//     final branchMapingResModel = branchMapingResModelFromJson(jsonString);

import 'dart:convert';

import '../../domain/entity/branch_maping_entity.dart';

BranchMapingResModel branchMapingResModelFromJson(String str) =>
    BranchMapingResModel.fromJson(json.decode(str));

String branchMapingResModelToJson(BranchMapingResModel data) =>
    json.encode(data.toJson());

class BranchMapingResModel extends BranchMapingResEntity {
  BranchMapingResModel({
    required status,
    required statusCode,
    required result,
  }) : super(status: status, result: result, statusCode: statusCode);

  factory BranchMapingResModel.fromJson(Map<String, dynamic> json) =>
      BranchMapingResModel(
        status: json["status"],
        statusCode: json["statusCode"],
        result: ResultEntity.fromJson(json["result"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "statusCode": statusCode,
        "result": result.toJson(),
      };
}

class Result extends ResultEntity {
  const Result({
    required message,
    required isAccept,
    branchId,
  }) : super(isAccept: isAccept, message: message, branchId: branchId);

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        message: json["message"],
        isAccept: json["isAccept"],
        branchId: json["branchId"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "isAccept": isAccept,
        "branchId": branchId,
      };
}
