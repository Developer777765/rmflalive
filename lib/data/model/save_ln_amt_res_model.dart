// To parse this JSON data, do
//
//     final saveLnAmtResModel = saveLnAmtResModelFromJson(jsonString);

import 'dart:convert';

import '../../domain/entity/save_loan_amt_res_entity.dart';

SaveLnAmtResModel saveLnAmtResModelFromJson(String str) =>
    SaveLnAmtResModel.fromJson(json.decode(str));

String saveLnAmtResModelToJson(SaveLnAmtResModel data) =>
    json.encode(data.toJson());

class SaveLnAmtResModel extends SaveLnAmtResEntity {
 const  SaveLnAmtResModel({
    required status,
    required statusCode,
    required result,
  }) : super(result: result, status: status, statusCode: statusCode);

  factory SaveLnAmtResModel.fromJson(Map<String, dynamic> json) =>
      SaveLnAmtResModel(
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
