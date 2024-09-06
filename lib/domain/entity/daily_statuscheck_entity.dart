//Response
import 'dart:convert';

import 'package:equatable/equatable.dart';

DailyStatusCheckResEntity dailyStatusCheckResFromJson(String str) =>
    DailyStatusCheckResEntity.fromJson(json.decode(str));

String dailyStatusCheckResToJson(DailyStatusCheckResEntity data) =>
    json.encode(data.toJson());

// ignore: must_be_immutable
class DailyStatusCheckResEntity extends Equatable {
  DailyStatusCheckResEntity({
    this.status,
    this.statusCode,
    this.result,
  });

  String? status;
  String? statusCode;
  List<DailyCheckResEntity>? result;

  factory DailyStatusCheckResEntity.fromJson(Map<String, dynamic> json) =>
      DailyStatusCheckResEntity(
        status: json["status"],
        statusCode: json["statusCode"],
        result: json["result"] == null
            ? []
            : List<DailyCheckResEntity>.from(
                json["result"]!.map((x) => DailyCheckResEntity.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "statusCode": statusCode,
        "result": result == null
            ? []
            : List<dynamic>.from(result!.map((x) => x.toJson())),
      };

  @override
  List<Object?> get props => [status, statusCode, result];
}

// ignore: must_be_immutable
class DailyCheckResEntity extends Equatable {
  DailyCheckResEntity({
    this.collectedDate,
    this.memName,
    this.loanNo,
    this.status,
  });

  DateTime? collectedDate;
  String? memName;
  String? loanNo;
  String? status;

  factory DailyCheckResEntity.fromJson(Map<String, dynamic> json) =>
      DailyCheckResEntity(
        collectedDate: json["collectedDate"] == null
            ? null
            : DateTime.parse(json["collectedDate"]),
        memName: json["memName"],
        loanNo: json["loanNo"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "collectedDate": collectedDate?.toIso8601String(),
        "memName": memName,
        "loanNo": loanNo,
        "status": status,
      };

  @override
  List<Object?> get props => [memName, loanNo, status];
}
