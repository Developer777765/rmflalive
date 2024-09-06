

import 'dart:convert';

import 'package:equatable/equatable.dart';

SaveLnAmtResEntity saveLnAmtResEntityFromJson(String str) =>
    SaveLnAmtResEntity.fromJson(json.decode(str));

String saveLnAmtResEntityToJson(SaveLnAmtResEntity data) =>
    json.encode(data.toJson());

class SaveLnAmtResEntity extends Equatable {
  const SaveLnAmtResEntity({
    required this.status,
    required this.statusCode,
    required this.result,
  });

  final String status;
  final String statusCode;
  final bool result;

  factory SaveLnAmtResEntity.fromJson(Map<String, dynamic> json) =>
      SaveLnAmtResEntity(
        status: json["status"],
        statusCode: json["statusCode"],
        result: json["result"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "statusCode": statusCode,
        "result": result,
      };

  @override
  List<Object?> get props => [status, statusCode, result];
}
