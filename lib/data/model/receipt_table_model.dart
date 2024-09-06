// ignore_for_file: public_member_api_docs, sort_constructors_first
// To parse this JSON data, do
//
//     final receiptTable = receiptTableFromJson(jsonString);

import 'dart:convert';

ReceiptTable receiptTableFromJson(String str) => ReceiptTable.fromJson(json.decode(str));

String receiptTableToJson(ReceiptTable data) => json.encode(data.toJson());

class ReceiptTable {
    ReceiptTable({
         this.branchId,
         this.prefix,
         this.sequence,
         this.suffix,
    });

      int? branchId;
     int? prefix;
     String? sequence;
     int? suffix;

    factory ReceiptTable.fromJson(Map<String, dynamic> json) => ReceiptTable(
        branchId: json["branchId"],
        prefix: json["prefix"],
        sequence: json["sequence"],
        suffix: json["suffix"],
    );

    Map<String, dynamic> toJson() => {
        "branchId": branchId,
        "prefix": prefix,
        "sequence": sequence,
        "suffix": suffix,
    };

  ReceiptTable copyWith({
    int? branchId,
    int? prefix,
    String? sequence,
    int? suffix,
  }) {
    return ReceiptTable(
      branchId: branchId ?? this.branchId,
      prefix: prefix ?? this.prefix,
      sequence: sequence ?? this.sequence,
      suffix: suffix ?? this.suffix,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'branchId': branchId,
      'prefix': prefix,
      'sequence': sequence,
      'suffix': suffix,
    };
  }

  factory ReceiptTable.fromMap(Map<String, dynamic> map) {
    return ReceiptTable(
      branchId: map['branchId'] as int,
      prefix: map['prefix'] as int,
      sequence: map['sequence'] as String,
      suffix: map['suffix'] as int,
    );
  }


  String toString() {
    return 'ReceiptTable(branchId: $branchId, prefix: $prefix, sequence: $sequence, suffix: $suffix)';
  }

  @override
  bool operator ==(covariant ReceiptTable other) {
    if (identical(this, other)) return true;
  
    return 
      other.branchId == branchId &&
      other.prefix == prefix &&
      other.sequence == sequence &&
      other.suffix == suffix;
  }

  @override
  int get hashCode {
    return branchId.hashCode ^
      prefix.hashCode ^
      sequence.hashCode ^
      suffix.hashCode;
  }
}
