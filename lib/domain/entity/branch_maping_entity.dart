// To parse this JSON data, do
//
//     final branchMapingResEntity = branchMapingResEntityFromJson(jsonString);

import 'dart:convert';

import 'package:equatable/equatable.dart';

// BranchMapingResEntity branchMapingResEntityFromJson(String str) => BranchMapingResEntity.fromJson(json.decode(str));

BranchMapingResEntity branchMapingResEntityFromJson(String str) {
  final jsonData = json.decode(str);
  return BranchMapingResEntity.fromJson(jsonData);
}

String branchMapingResEntityToJson(BranchMapingResEntity data) =>
    json.encode(data.toJson());

class BranchMapingResEntity extends Equatable {
  BranchMapingResEntity({
    required this.status,
    required this.statusCode,
    required this.result,
  });

  final String status;
  final String statusCode;
  final ResultEntity result;

  factory BranchMapingResEntity.fromJson(Map<String, dynamic> json) =>
      BranchMapingResEntity(
        status: json["status"],
        statusCode: json["statusCode"],
        result: ResultEntity.fromJson(json["result"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "statusCode": statusCode,
        "result": result.toJson(),
      };

  @override
  List<Object?> get props => [status, statusCode, result];
}

class ResultEntity extends Equatable {
  const ResultEntity({
    required this.message,
    required this.isAccept,
    this.branchId,
  });

  final dynamic message;
  final bool? isAccept;
  final dynamic branchId;

  factory ResultEntity.fromJson(Map<String, dynamic> json) => ResultEntity(
        message: json["message"],
        isAccept: json["isAccept"],
        branchId: json["branchId"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "isAccept": isAccept,
        "branchId": branchId,
      };

  @override
  List<Object?> get props => [message, isAccept, branchId];
}
